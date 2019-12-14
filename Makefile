create: load_lambda deploy_stack

update: update_stack

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
	-aws s3api create-bucket --bucket api-test-2019-lambda-functions --region us-east-1
	
	@echo
	@echo '[Uploading lambda functions to S3 Bucket..]'
	aws s3 cp functions/save_image.zip s3://api-test-2019-lambda-functions/
	aws s3 cp functions/list_image.zip s3://api-test-2019-lambda-functions/

deploy_stack:
	@echo
	@echo '[Deploying stack..]'
	aws cloudformation create-stack --stack-name api-test --template-body 'file://./infrastructure/api_test_stack.json' --capabilities CAPABILITY_NAMED_IAM

delete_stack:
	@echo
	@echo '[Cleaning images S3 Bucket]'
	-aws s3 rm s3://api-test-2019-saved-images --recursive
	
	@echo
	@echo '[Deleting stack..]'
	aws cloudformation delete-stack --stack-name api-test

unload_lambda:
	@echo
	@echo '[Deleting generated packages..]'
	-rm functions/save_image.zip
	-rm functions/list_image.zip
	-rm -rf functions/.packages
	
	@echo
	@echo '[Cleaning S3 Bucket..]'
	-aws s3 rm s3://api-test-2019-lambda-functions --recursive
	
	@echo
	@echo '[Deleting S3 Bucket..]'
	-aws s3 rb s3://api-test-2019-lambda-functions

update_stack:
	@echo
	@echo '[Updating stack..]'
	aws cloudformation update-stack --stack-name api-test --template-body 'file://./infrastructure/api_test_stack.json' --capabilities CAPABILITY_NAMED_IAM
