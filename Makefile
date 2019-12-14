Zip lambda files
`zip functions/zip/list_image.zip functions/list_image/index.py`
`zip functions/zip/save_image.zip functions/save_image/index.py`

Create a new S3 to store the lambda functions as follows
`aws s3api create-bucket --bucket api-test-2019-lambda-functions --region us-east-1`
`aws s3 cp functions/zip/ s3://api-test-2019-lambda-functions/ --recursive`

Upload the lambda functions:
`aws s3 cp functions/zip/ s3://api-test-2019-lambda-functions/ --recursive`

Deploy the local JSON stack using AWS cli
`aws cloudformation create-stack --stack-name api-test --template-body 'file://./infrastructure\s3.json' --capabilities CAPABILITY_NAMED_IAM`

# Rollback

Delete stack
`aws cloudformation delete-stack --stack-name api-test`