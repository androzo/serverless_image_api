create: load_lambda deploy_stack

destroy: delete_stack unload_lambda

load_lambda:
	@echo
	@echo '[Installing dependencies..]'	
	pip install requests -t functions/.packages/
	
	@echo
	@echo '[Zipping lambda functions..]'
	cd functions; zip save_image.zip save_image.py
	cd functions; zip list_image.zip list_image.py
	cd functions/.packages; zip -r ../save_image.zip *
	
	@echo
	@echo '[Creating new S3 Bucket..]'
	-aws s3api create-bucket --bucket $(lambda_bucket) --region us-east-1
	
	@echo
	@echo '[Uploading lambda functions to S3 Bucket..]'
	aws s3 cp functions/save_image.zip s3://$(lambda_bucket)/
	aws s3 cp functions/list_image.zip s3://$(lambda_bucket)/

deploy_stack:
	@echo
	@echo '[Deploying stack..]'
	aws cloudformation create-stack \
		--stack-name $(stack_name) \
		--template-body 'file://./infrastructure/stack.json' \
		--capabilities CAPABILITY_NAMED_IAM \
		--parameters ParameterKey=ImageS3BucketName,ParameterValue=$(image_bucket) ParameterKey=LambdaS3BucketName,ParameterValue=$(lambda_bucket)

delete_stack:
	@echo
	@echo '[Cleaning images S3 Bucket]'
	-aws s3 rm s3://$(image_bucket) --recursive
	
	@echo
	@echo '[Deleting stack..]'
	aws cloudformation delete-stack --stack-name $(stack_name)

unload_lambda:
	@echo
	@echo '[Deleting generated packages..]'
	-rm functions/save_image.zip
	-rm functions/list_image.zip
	-rm -rf functions/.packages
	
	@echo
	@echo '[Cleaning S3 Bucket..]'
	-aws s3 rm s3://$(lambda_bucket) --recursive
	
	@echo
	@echo '[Deleting S3 Bucket..]'
	-aws s3 rb s3://$(lambda_bucket)

update_stack:
	@echo
	@echo '[Updating stack..]'
	aws cloudformation update-stack --stack-name $(stack_name) \
		--template-body 'file://./infrastructure/stack.json' \
		--capabilities CAPABILITY_NAMED_IAM \
		--parameters ParameterKey=ImageS3BucketName,ParameterValue=$(image_bucket) ParameterKey=LambdaS3BucketName,ParameterValue=$(lambda_bucket) 

get_stack_info:
	aws cloudformation describe-stacks --stack-name $(stack_name) --query 'Stacks[0].Outputs[0].OutputValue'
	aws cloudformation describe-stacks --stack-name $(stack_name) --query 'Stacks[0].Outputs[1].OutputValue'
	aws cloudformation describe-stacks --stack-name $(stack_name) --query 'Stacks[0].Outputs[2].OutputValue'