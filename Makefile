all: load_lambda deploy_stack

tear_down: delete_stack unload_lambda

load_lambda:
	@echo "[Zipping lambda functions..]"
	pip install requests -t functions/packages/
	cd functions; zip save_image.zip save_image.py
	cd functions; zip list_image.zip list_image.py
	cd functions/packages; zip ../save_image.zip *
	@echo "[Creating new S3 Bucket..]"
	aws s3api create-bucket --bucket api-test-2019-lambda-functions --region us-east-1
	@echo "[Uploading lambda functions to S3 Bucket..]"
	aws s3 cp functions/save_image.zip s3://api-test-2019-lambda-functions/
	aws s3 cp functions/list_image.zip s3://api-test-2019-lambda-functions/

deploy_stack:
	@echo "[Deploying stack..]"
	aws cloudformation create-stack --stack-name api-test --template-body 'file://./infrastructure/api_test_stack.json' --capabilities CAPABILITY_NAMED_IAM

delete_stack:
	@echo "[Cleaning images S3 Bucket]"
	aws s3 rm s3://api-test-2019-saved-images --recursive
	@echo "[Deleting stack..]"
	aws cloudformation delete-stack --stack-name api-test

unload_lambda:
	@echo "[Deleting generated packages..]"
	rm zip/save_image.zip
	rm zip/list_image.zip
	@echo "[Cleaning S3 Bucket..]"
	aws s3 rm s3://api-test-2019-lambda-functions --recursive
	@echo "[Deleting S3 Bucket..]"
	aws s3 rb s3://api-test-2019-lambda-functions
