# PHIMS
Cloud-based Personal Health Information Management System (PHIMS) is an application that provides university students with a more convenient way of monitoring their personal health records (PHR).

## Prerequisites
- This application requires the following to be installed in your system:
  1. Ruby on Rails
  2. PostgreSQL (with a user named `phims`)

- You also need to have an Amazon Web Service (AWS) account if you want the storage to be on a cloud service. To create an account, click [here](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/).

## Installation
1. Clone this repository
  `git clone https://github.com/charlesjom/PHIMS.git`
2. Go to the directory of the repository
  `cd PHIMS`
3. Run `bundle install`
4. Run `gem install mailcatcher`
5. Run `mailcatcher`
6. Run `rake db:create`
6. Run `rake db:migrate
7. To use AWS S3 as the application's file storage:
   1. Run `EDITOR=nano rails credentials:edit`
   2. Follow the format below:
      ```
      production:
        aws:
          access_key_id: <YOUR_ACCESS_ID_FROM_AWS>
          secret_access_key: <YOUR_SECRET_ACCESS_KEY_FROM_AWS>
          bucket: phims-uplb
          region: <YOUR_AWS_SERVICE_REGION>
      ```
8. To run the server on your machine (default IP address is 0.0.0.0 or localhost, default port is 3000):
   - First, assign value to environment variable `DATABASE_PASSWORD` using `export DATABASE_PASSWORD=<your_database_password_for_user_phims>`, then run `rails s -b <your_ip_address> [-p <port_number>]`; or
   - Just run `DATABASE_PASSWORD=<your_database_password_for_user_phims> rails s` 
  
## Notes
* E-mail messages can be accessed in `<localhost/your_ip_address>:1080`

## Authors
* Charles Jo U. Marquez - Student
* Prof. Joseph Anthony C. Hermocilla - Faculty Adviser
