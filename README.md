# API Test

This stack will create two APIs that will save an image to an S3 bucket and list all objects in the bucket

1. /save_image
POST
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

## How to deploy

aws cloudformation create-stack --stack-name api-test --template-body file://./infrastructure\s3.json' --capabilities CAPABILITY_NAMED_IAM 

## Testing

Test url >
http://127.0.0.1:5000/save_image?name=buka.jpeg&url=https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg




