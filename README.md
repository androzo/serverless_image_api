# API Test

This stack will create two APIs that will save an image to an S3 bucket and list all objects in the bucket

1. [POST] /save_image?name=sample_image_name.jpeg&url=https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg

`
{
    url: "https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg",
    name: "sample_image_name.jpeg"
}
`
2. /list_images
GET


## Requirements

* AWS cli installed and configured https://docs.aws.amazon.com/pt_br/cli/latest/userguide/cli-chap-install.html


# Deploy
* Windows
`.\operations.ps1 -deployStack  `
- By default scripts are disabled in Windows. Enable by running `Set-ExecutionPolicy unrestricted` before running the script

* Linux
<<create makefile to automate linux and mac>>
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

## Testing

Test url >
http://127.0.0.1:5000/save_image?name=buka.jpeg&url=https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg




