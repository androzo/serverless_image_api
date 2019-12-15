# API Test

This stack creates two rest APIs using serverless architecture.


## Requirements

* AWS cli installed and configured https://docs.aws.amazon.com/pt_br/cli/latest/userguide/cli-chap-install.html
* Postman (or another AWS Signature compatible tool)
* Linux or MacOS

### Deploy
Deploys the infrastructure to AWS account that is configured in the awscli:
```
$ make all
```
*Additionally, you can run `make update_stack` to update your stack, and `make destroy` to tear down the environment.

## Authentication
In order to secure authentication to requests, AWS Signature is used.
- Run `make get_keys` to retrieve keys automatically generated
- Run `make get_endpoints` to retrieve API Gateway endpoints

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

  `{"url": "https://icons.com/icon_f7021.png","name": "my_icon.png"}`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:**  `{ "result" : "Saved successfully", "name" : name, "storage" : s3_path, "date" : date_time }` 
 
* **Error Response:**

    **Content:** `{ result : "Failed to save image",  error : "<error_stack>" }`


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