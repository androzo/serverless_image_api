# Image API

This stack creates a REST API using serverless architecture in AWS. Two features are available in the API, save an image from a URL to an S3 Bucket, and list all images saved on the Bucket.

![Design](design.png?raw=true "Architecture design diagram")

## Requirements

* AWS cli installed and configured https://docs.aws.amazon.com/pt_br/cli/latest/userguide/cli-chap-install.html
* Postman (or another AWS Signature compatible tool)
* Linux or MacOS

## Deploy the infrastructure
First you need to set your environment variables in order to customize resource names as you like:
* stack_name: CloudFormation Stack
* image_bucket: S3 Bucket that will store saved images
* lambda_bucket: S3 BUcket that will store Lambda functions
```
$ export stack_name=sample-image-api-stack \
         image_bucket=sample-image-api-saved-images \
         lambda_bucket=sample-image-api-functions
```
<_To change these values later run "unset my_var" and run the export command again_>

Deploys the infrastructure to AWS account that is configured in the awscli:
```
$ make create
```
*Additionally, you can run `make update_stack` to update your stack, and `make destroy` to tear down the environment.

## Authentication & Endpoint URL
In order to secure authentication to requests, AWS Signature is used.
Get outputs from the stack once the infrastructure is deployed running:
 ```
 make get_stack_info
 ```
 * The below cmdlet retrieve the keys and endpoints required for testing

**List Images**
----
  Returns json data with images save in the S3 Bucket.

* **URL**

  /list_images

* **Method:**

  `POST`

* **Data Params**

  None

* **Success Response:**

  * **Code:** 200 <br />
    **Content:**  `{ "saved_images": [ "image.png", "image1.png" ] }` 
 
* **Error Response:**

    **Content:** `{ result : "Failed to list images",  error : "<error_stack>" }`


**Save Image**
----
  Saves image in a S3 bucket and logs additional information on a DynamoDB Table.

* **URL**

  /save_image

* **Method:**

  `POST`

* **Data Params**

  `{ "url": "https://a_sample_image_site.com/some_image.png","name": "my_image.png" }`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:**  `{ "result" : "Saved successfully", "name" : name, "storage" : s3_path, "date" : date_time }` 
 
* **Error Response:**

    **Content:** `{ result : "Failed to save image",  error : "<error_stack>" }`

## Future improvements
* Encrypt S3 Bucket using KMS keys in Lambda
* Replace AWS Signature authentication method by tokens
* Create automated REST API tests

## AWS Cloudformation Resources
- AWS::IAM::User
- AWS::IAM::AccessKey
- AWS::IAM::Role
- AWS::IAM::ManagedPolicy
- AWS::S3::Bucket
- AWS::S3::BucketPolicy
- AWS::ApiGateway::Account
- AWS::ApiGateway::Stage
- AWS::ApiGateway::RestApi
- AWS::ApiGateway::Deployment
- AWS::ApiGateway::RestApi
- AWS::Lambda::Function
- AWS::Logs::LogGroup
- AWS::DynamoDB::Table