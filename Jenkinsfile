//Default color values for slack messages
import groovy.json.JsonSlurperClassic
 
def red = '#FF0000'
def yellow = '#FFFF00'
def green = '#00FF00'

/**********************/
/**Declaritive Syntax**/
/**********************/

//Containers defined in spec

// Jnlp - Overwrites default pod that checks out source code initially. Source code is checked out implicitly,
//        before the explicitly defined stages are executed. In order to checkout from github
//        the va certs need to be installed on the container. This is why we use the jenkins-slave:3.29-1 image which has the certs installed.
//        Otherwise, upon running the pipeline you would get a 'inappropriate fallback' error, if the certs aren't installed.
//
// Salesforce - At the time of writing this, there wasn't a bip-platform image that had Salesforce CLI installed. In order to fix this we use a custom image
//       named salesforcedx:latest-full. This image is used to create a side car container installs all dependencies the project has. 
//       
//  Note on containers created by kubernetes plugin:
//  
//   In the pod spec a single pod is defined, that has at least a single container within it (jnlp - checkouts out source code). 
//   All containers in this pod share a single volume that contains the source code. For example, I could compile the source code
//   and create a jar with one stage, using one container, and then build the image in the next stage, using another container. All
//   without having to copy files between containers.

node {
  
    def SF_USERNAME = "reachshas05@gmail.com"
    def SF_CONSUMER_KEY = "3MVG9cHH2bfKACZbbERCrK9I9alLz9fkHB5A4TSNX9AIptJC3aZQ5uO_SbDGAoZz.gbmbFeVk4iLDQX5cpoeu"
    def SERVER_KEY_CREDENTIALS_ID = "8f99c6a7-2d55-4c9a-8f03-bbf33f9da9eb"
    def SF_INSTANCE_URL = "https://login.salesforce.com"

    stage('Checkout Source') {
        echo 'Checking out source files..'
        checkout scm
    }

    // ------------------------------------------------------------------------------
    // Run all the enclosed stages with access to the Salesforce JWT key credentials.
    // ------------------------------------------------------------------------------

    // -------------------------------------------------------------------------
    // Authorize the Dev Hub org with JWT key and give it an alias.
    // Deploy the source manifest to environment
    // -------------------------------------------------------------------------
    stage('Test Coverage') {
        echo "Using the ${SERVER_KEY_CREDENTIALS_ID} credentials.."
        withCredentials([file(credentialsId: SERVER_KEY_CREDENTIALS_ID, variable: 'server_key_file')]) {
            echo "Setting the Audience URL to ${SF_INSTANCE_URL} ..."
            sh "export SFDX_AUDIENCE_URL=${SF_INSTANCE_URL}"
            echo 'Authenticating to SFDX..'
            sh "sfdx auth:jwt:grant --instanceurl ${SF_INSTANCE_URL} --clientid ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwtkeyfile ${server_key_file} --setdefaultdevhubusername --setalias MyOrg"
            echo "Code Coverage"
            sh "sfdx force:apex:test:run -s "mySuite" -c -u MyOrg"
        }
    }
  
}
