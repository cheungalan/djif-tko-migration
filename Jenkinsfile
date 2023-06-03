#!/usr/bin/env groovy
/* vim: ft=groovy syntax=groovy
/* -*- mode: groovy; coding: utf-8 -*- */
import java.text.SimpleDateFormat
import groovy.io.FileType

terraformBinary = 'terraform-0.13.7'
lob = 'djif'   // part of the Terraform `subpath` definition. Change lob to whatever Business Unit owns the Jenkins server

// BEGIN Jenkins job parameters menus
properties([parameters([
    booleanParam(defaultValue: true, description: 'Select to populate new accounts', name: 'populate_accounts'), 
    choice(choices: ["plan","apply","destroy"], description: '', name: 'action'), 
    choice(choices: ["no","yes"], description: '', name: 'import_script'),
    [$class: 'ChoiceParameter', choiceType: 'PT_SINGLE_SELECT', description: 'Choose account', filterLength: 1, filterable: false, name: 'account', randomName: 'choice-parameter-11218045538499', 
    script: [$class: 'GroovyScript', fallbackScript: [classpath: [], sandbox: false, script: ''], 
    script: [classpath: [], sandbox: true, script: '''
    import groovy.io.FileType
    def  accountList = [] 
    new File("${env.WORKSPACE}/accounts/").eachDir()
    {
        dirs -> dirs.getName() 
        if (!dirs.getName().startsWith(\'.\')) {
            accountList.add(dirs.getName()) 
        }
    }
    accountList.add(\'all\')
    return accountList.sort()''']]], 
    [$class: 'CascadeChoiceParameter', choiceType: 'PT_SINGLE_SELECT', description: 'Choose region', filterLength: 1, filterable: false, name: 'region', randomName: 'choice-parameter-11218050093680', referencedParameters: 'account', script: [$class: 'GroovyScript', fallbackScript: [classpath: [], sandbox: false, script: ''], script: [classpath: [], sandbox: true, script: '''
    import groovy.io.FileType
    def  regionList = []
    if ("${account}" == "") {
        return regionList // empty
    }
    if ( "${account}"=="all") {
        // "basename $(find . -depth 2)  | sort | uniq".execute()
        regionList.add("all regions found")
    } else {
        new File("${env.WORKSPACE}/accounts/${account}").eachDir()
        {
            dirs -> dirs.getName()
            if (!dirs.getName().startsWith(\'.\')) {
                regionList.add(dirs.getName())
            }
        }
    }
    return regionList.sort()''']]], 
    booleanParam(defaultValue: false, description: 'If on, more traces will be printed.', name: 'debug'), 
    choice(choices: ["NONE","ERROR","WARN","INFO","DEBUG","TRACE"], description: 'log level for TF_LOG ', name: 'tfLogLevel')])])
// END Jenkins job parameters menus

@NonCPS
def getRegions(account, requestedRegion, debug)
{
    if (debug) {
        print ("looking at regions for account ${account} in path ${env.WORKSPACE}/accounts/${account}")
    }
    def  regionList = []
    if (requestedRegion == "all regions found") {
        new File("${env.WORKSPACE}/accounts/${account}").eachDir()
        {
            dirs -> dirs.getName()
            if (debug) {
                print "found region: ${dirs.getName()} for account:${account}"
            }
            if (!dirs.getName().startsWith('.')) {
                regionList.add(dirs.getName())
            }
        }   
    } else {
        regionList.add(requestedRegion)
    }
    return regionList.sort()
}

// returns map of acccounts to build. If the user requested one account return that one, if they requested
// all accounts read their values from disk and return that.
@NonCPS
def getAccounts(requestedAccount, requestedRegion, debug)
{
    def accountsMap = [:]
    def regions = ""

    if (requestedAccount == 'all') { // if we want all accounts, read them from the checkout dir
        new File("${env.WORKSPACE}/accounts/").eachDir() {
            dirs -> dirs.getName()
            if (!dirs.getName().startsWith('.')) {
                accountName = dirs.getName()
                regions = getRegions(accountName, requestedRegion, debug)
                accountsMap[accountName] = regions
            }
        }
    } else {
        accountName = requestedAccount
        regions = getRegions(accountName, requestedRegion, debug)
        accountsMap[accountName] = regions
    }
    return accountsMap
}

//@NonCPS
def getEnvironment(accountName, region, debug)
{
    if (debug) {
        print "getEnvironment params accounts: ${accountName} and region: ${region}"
    }
    def environment = "accounts/${accountName}/${region}"
    if (debug) {
        print "getEnvironment returns ${environment}"
    }
    return environment
}

// get user parameters and return a map of the values. 
def getParameters() {
    def myParams  = [:] 
    myParams["account"] = "${params.account}"
    myParams["region"] = "${params.region}"
    myParams["action"] = "${params.action}"
    myParams["import_script"] = "${params.import_script}"
    if ("${params.populate_accounts}" == "true" ) {
        myParams["populate_accounts"] = true
    } else {
        myParams["populate_accounts"] = false
    }
    if ("${params.debug}" == "true" ) {
        myParams["debug"] = true
    } else {
        myParams["debug"] = false
    }
    if ("${params.tfLogLevel}" == "NONE") {
        myParams["TF_LOG"] = ""
    } else {
        myParams["TF_LOG"] = "${params.tfLogLevel}"
    }
    ansiColor('xterm') {
        echo "\u001B[34mArguments Supplied/Computed -\n   account: ${myParams["account"]} \n    region: ${myParams["region"]} \n    action: ${myParams["action"]} \n import_script: ${myParams["import_script"]}\n    PopulateAccounts: ${myParams["populate_accounts"]}\u001B[0m"
        echo "\u001B[34mDebug:${myParams["debug"]} and TF_LOG:${myParams["TF_LOG"]}\u001B[0m\n"
    }
    return myParams
}

// Update git repo on master before anything else
// Running the job with an empty account field will populate the field with new accounts
def checkoutRepo(){
    dir("${env.WORKSPACE}") {
        //checkout scm
        // use shallow checkout instead.
        checkout([
            $class: 'GitSCM',
            branches: scm.branches,
            doGenerateSubmoduleConfigurations: false,
            extensions: [[$class: 'CloneOption', depth: 1, noTags: true, reference: '', shallow: true]],
            submoduleCfg: [],
            userRemoteConfigs: scm.userRemoteConfigs]
        )
    }
}

// Remove tfstate and status files to start clean
def tfCleanState (environment){
    if (fileExists("${env.WORKSPACE}/${environment}/.terraform/terraform.tfstate")) {
        def rmCmd = "rm -rf ${env.WORKSPACE}/${environment}/.terraform/terraform.tfstate"
        def exitCode = sh(returnStatus: true, script: rmCmd)
        if (exitCode != 0) {
            currentBuild.result = 'FAILED'
            error "${rmCmd} failed for account: ${accountName} env = ${environment}"
        }
    }
}

// Get approval from Jenkins user via web gui
def tfApproval (action){
    try {
        if (action == "apply"){
            input (message: 'Apply Plan?', ok: 'Apply')
            return true
        } else if (action == "destroy"){
            input (message: 'Destroy Everything?', ok: 'Destroy')
            return true
        }
    }
    catch (err) {
        currentBuild.result = 'FAILURE'
        return false
    }
}

def tfCheckout (accountName, region, debug){   
    // Clean the workspace
    def environment = getEnvironment(accountName, region, debug)
    if (debug) {
        print "STEP: tfCheckout"
        print "account = ${accountName} env = ${environment}"
        print "workspace is ${env.WORKSPACE}"
    }
    deleteDir()
    // Get the repo from GitHub
    checkoutRepo()
    // Copy base folder into environment subfolder
    def exitCode = sh(returnStatus: true, script: "cp ${env.WORKSPACE}/base/* ${env.WORKSPACE}/${environment}")
    if (exitCode != 0) {
        currentBuild.result = 'FAILED'
        error 'Copy base files failed'
    }
}

def tfInit (accountName, region, subpath, importScript, debug, tfLogLevel){
    def environment = getEnvironment(accountName, region, debug)

    if (debug) {
        print "STEP: tfInit"
        print "account = ${accountName} env = ${environment}"
        print "tfInit workspace is ${env.WORKSPACE}"
    }
    tfCleanState (environment)
    // Initialize Terraform with Artifactory backend
    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dowjones-artifactory-credentials',
                    usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
        
        def execInit = """
            cd ${env.WORKSPACE}/${environment}; export TF_LOG=${tfLogLevel}; \
            yes yes 2>&1 | ${terraformBinary} init \
            -backend-config="username=${USERNAME}" \
            -backend-config="password=${PASSWORD}" \
            -backend-config="subpath=${subpath}"
        """
        def exitCode = sh(returnStatus: true, script: execInit)
        if (exitCode != 0) {
            if (debug) {
                sh(returnStatus: true, script: "ls -al ${env.WORKSPACE}/${environment}/.terraform/;cat ${env.WORKSPACE}/${environment}/.terraform/terraform.tfstate")
            }
            currentBuild.result = 'FAILED'
            error "TfInit failed for account: ${accountName} env = ${environment}"
        }
    }
    if (debug) {
        print "import script is ${importScript}"
    }
    if ("${importScript}" == "yes") {
        def importScriptSh  = "cd ${env.WORKSPACE}/${environment} && ${env.WORKSPACE}/${environment}/import.sh ${accountName} ${importScript}"
        def exitCode = sh(returnStatus: true, script: importScriptSh)
        if (exitCode != 0) {
            currentBuild.result = 'FAILED'
            error "${importScriptSh} failed for account: ${accountName} env = ${environment}"
        }
    }
}

def tfValidate (accountName, region, debug, tfLogLevel){
    def environment = getEnvironment(accountName, region, debug)
    if (debug) {
        print "STEP: tfValidate"
        print "account = ${accountName} env = ${environment}"
        print "workspace is ${env.WORKSPACE}"
    }
    // Output Terraform version
    def terraformVersionSh = "${terraformBinary} --version"
    def exitCode = sh(returnStatus: true, script: terraformVersionSh)
    if (exitCode != 0) {
        currentBuild.result = 'FAILED'
        error "${terraformVersionSh} failed for account: ${accountName} env= ${environment}"
    }
    // Validate Terraform files
    def terraformValidate = "cd ${env.WORKSPACE}/${environment}; export TF_LOG=${tfLogLevel}; ${terraformBinary} validate"
    exitCode = sh(returnStatus: true, script: terraformValidate)
    if (exitCode != 0) {
        currentBuild.result = 'FAILED'
        error "${terraformValidate} failed for account: ${accountName} env = ${environment}"
    }
}

def tfPlan (accountName, region, action, debug, tfLogLevel){
    def environment = getEnvironment(accountName, region, debug)
    if (debug) {
        print "STEP: tfPlan"
        print "account = ${accountName} env = ${environment}"
        print "workspace is ${env.WORKSPACE}"
    }
    def execPlan
    if (action != "destroy"){
        execPlan = """
            cd ${env.WORKSPACE}/${environment}; export TF_LOG=${tfLogLevel}; ${terraformBinary} get -update; \
            set +e; ${terraformBinary} plan -out=plan.out -detailed-exitcode; \
        """
    } else { // Else perform plan with destroy option
        execPlan = """ 
            cd ${env.WORKSPACE}/${environment}; export TF_LOG=${tfLogLevel}; ${terraformBinary} get -update; \
            set +e; ${terraformBinary} plan -destroy -out=plan.out -detailed-exitcode; \
        """
    }
    def exitCode = sh(returnStatus: true, script: execPlan)
    if (exitCode == 0) {
        echo "\u001B[34mTerraform plan succeeded with no changes\u001B[0m"
        return false
    } else if (exitCode == 1) {
        echo "\u001B[34mTerraform plan plan error\u001B[0m"
        error ("Terraform plan error for account = ${accountName} , env = ${environment}")
        currentBuild.result = 'FAILURE'
        return false
    } else if (exitCode == 2) {
        echo "\u001B[34mTerraform plan succeeded with changes present.\u001B[0m"
        return true
    }
}

def tfApplyDestroy(accountName, region, action, tfPlanOk, debug, tfLogLevel){
    def environment = getEnvironment(accountName, region, debug)
    if (debug) {
        print "STEP: tfApplyDestroy"
        print "account = ${accountName} env = ${environment}"
        print "tfApplyDestroy workspace is ${env.WORKSPACE}"
    }
    if (action == "apply" && tfPlanOk == true) {
        try {
            // Apply plan
            def execApply = """
                cd ${env.WORKSPACE}/${environment}; set +e; export TF_LOG=${tfLogLevel}; ${terraformBinary} apply plan.out; \
            """
            def applyExitCode = sh(returnStatus: true, script: execApply)
            if (applyExitCode == 0) {
                echo "\u001B[34m${environment} ${env.JOB_NAME} - ${env.BUILD_NUMBER} - Changes applied.\u001B[0m"
            } else {
                currentBuild.result = 'FAILURE'
                echo "\u001B[31m${environment} ${env.JOB_NAME} - ${env.BUILD_NUMBER} - Error applying plan!\u001B[0m"
                error ("Terraform apply error for account = ${accountName} , env = ${environment}")
            }
        } catch (err) {
            currentBuild.result = 'FAILURE'
            echo "\u001B[31m${environment} ${env.JOB_NAME} - ${env.BUILD_NUMBER} - Error caught applying!\u001B[0m"
            error ("Terraform apply error for account = ${accountName} , env = ${environment}")
        }
    }
    else if (action == "destroy" && tfPlanOk == true) {
        try {
            timeout(time: 30, unit:'MINUTES') {
                tfApproval = tfApproval(action)
                if (tfApproval == true) {   
                    // Destroy apply
                    def execDestroy = """
                        cd ${env.WORKSPACE}/${environment}; export TF_LOG=${tfLogLevel};set +e; ${terraformBinary} destroy -force; 
                    """
                    def destroyExitCode = sh(returnStatus: true, script: execDestroy)
                    if (destroyExitCode == 0) {
                        echo "\u001B[34m${environment} ${env.JOB_NAME} - ${env.BUILD_NUMBER} - Infrastructure destroyed.\u001B[0m"
                    } else if (destroyExitCode == 2) {
                        echo "\u001B[34m${environment} ${env.JOB_NAME} - ${env.BUILD_NUMBER} - Nothing to destroy for account = ${accountName} env = ${environment}.\u001B[0m"
                    } else {
                        currentBuild.result = 'FAILURE'
                        echo "\u001B[31m${environment} ${env.JOB_NAME} - ${env.BUILD_NUMBER} - Error destroying!\u001B[0m"
                    }   
                }
            } 
        } catch (err) {
            currentBuild.result = 'FAILURE'
            echo "\u001B[31m${environment} ${env.JOB_NAME} - ${env.BUILD_NUMBER} - Error caught destroying!\u001B[0m"
        }
    }
}

def runTfSteps(accountName, region, action, importScript, debug, tfLogLevel) {
    def lob = "djif"  // Change lob to whatever Business Unit owns the Jenkins server
    def subpath = "${lob}/${env.JOB_NAME}/${accountName}/${region}/"
    ansiColor('xterm') {
        if (debug) {
            print "calling tfCheckout with account: ${accountName} and region: ${region}"
        }
        tfCheckout (accountName, region, debug)
        tfInit (accountName, region, subpath, importScript, debug, tfLogLevel)
        tfValidate(accountName, region, debug, tfLogLevel)
        def tfPlanOk = tfPlan (accountName, region, action, debug, tfLogLevel)
        tfApplyDestroy(accountName, region, action, tfPlanOk, debug, tfLogLevel)
    }
}

def build(requestedAccounts, requestedRegions, action, importScript, debug, tfLogLevel) {
    def accountToBuild = [:]
    def accountMap = [:]
    accountMap = getAccounts(requestedAccounts, requestedRegions, debug)
    if (debug) {
        print "accounts are = ${accountMap}"
    }
    //why we must use .each: https://stackoverflow.com/questions/42039851/jenkins-groovy-parallel-variable-not-working
    accountMap.each { accountName, regionList ->
        // bind names, see https://jenkins.io/doc/pipeline/examples/#parallel-multiple-nodes
        def localAccountName = accountName
        def localRegionList = regionList
        def regionSize = localRegionList.size()
        accountToBuild[localAccountName] = {
            stage(localAccountName){
                node('admin'){
                    for (int i=0; i < regionSize; i++) {
                        // bind i, see https://jenkins.io/doc/pipeline/examples/#parallel-multiple-nodes
                        def regionIndex = i
                        def region = "${localRegionList[regionIndex]}"
                        runTfSteps(localAccountName, region, action, importScript, debug, tfLogLevel)
                    }
                }
            }
        }
    }
    parallel accountToBuild
}

// flow: 
// 1) get user parameters
// from master node, launch each nodes, 1 per account. 
myParams = getParameters()
node ('master') {
    stage("checkout acccount data") {
        deleteDir()
        checkoutRepo()
    }
    if (myParams["populate_accounts"]){  // if we're populating accounts data, then we only wanted to do that (checkout above), and exit with success.
        currentBuild.displayName = "${BUILD_NUMBER} :: Populate accounts"
        print "accounts data populated\n"
        currentBuild.result = 'SUCCESS'
        return
    } else { // otherwise go run what the user asked for.
        currentBuild.displayName = "${BUILD_NUMBER} :: ${myParams['action']} account:${myParams['account']} region:${myParams['region']}"
        wrap([$class: 'BuildUser']) {
            currentBuild.setDescription("by ${BUILD_USER}")
        }
        build(myParams["account"], myParams["region"], myParams["action"], myParams["import_script"], myParams["debug"], myParams["TF_LOG"]) 
    }
}
