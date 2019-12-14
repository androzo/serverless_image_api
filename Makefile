initialize: zip_lambda create_s3_bucket upload_lambda deploy_stack

zip_lambda:
	zip zip/list_image.zip list_image.py
	zip zip/save_image.zip save_image.py

create_s3_bucket:
	aws s3api create-bucket --bucket api-test-2019-lambda-functions --region us-east-1

upload_lambda:
	aws s3 cp zip/ s3://api-test-2019-lambda-functions/ --recursive

deploy_stack:
	aws cloudformation create-stack --stack-name api-test --template-body 'file://./infrastructure/api_test_stack.json' --capabilities CAPABILITY_NAMED_IAM

delete_stack:
	aws cloudformation delete-stack --stack-name api-test

delete_s3_bucket:
	aws s3 rm s3://api-test-2019-lambda-functions --recursive
