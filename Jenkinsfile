properties([
  parameters([
    string(name: 'rolesToPlay', defaultValue: ''),
    string(name: 'modulesToRun', defaultValue: ''),
    string(name: 'ansibleImage', defaultValue: 'unicanova/ansible:0.0.1-1'),
    string(name: 'terraformImage', defaultValue: 'terraform'),
    string(name: 'awsCredentials', defaultValue: 'AWS_ACCESS'),
  ])
])

// Form array of roles desired to be played to be played

rolesToPlay = params.rolesToPlay.replaceAll("\\s","").split(',')
modulesToRun = params.modulesToRun.replaceAll("\\s","").split(',')

node (label: 'docker-machine') {
  stage('Checkout') {
    checkout scm
  }

  stage('Run Roles') {
    when {
        // Only run if rolesToPlay has any values
        expression { rolesToPlay }
    }
    // Verify that roles to be played are defined in repository
    def rolesDefined = readYaml file: 'roles-defined.yml'
    rolesDefinedList = rolesDefined['rolesDefined']

    println "Roles desired to be played are ${rolesToPlay} \
          Defined roles are ${rolesDefinedList}"
    println "Only roles that are both defined in roles-defined.yml file \
          and are provided in rolesToPlay job parameter will be played"

    for (role in rolesToPlay) {
      if (rolesDefinedList.contains(role)){
        // Role is defined, playing it
        echo "Playing ansible role ${role}"
        docker.image(params.ansibleImage).inside("-e ANSIBLE_ROLES_PATH='roles' -v /etc/passwd:/etc/passwd:ro" ) {

          sh "HOME=\$WORKSPACE ansible-galaxy -vvvvv install -p roles -r play/${role}/requirements.yml"
          sh "cp -ar play/${role} roles/"
          withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding', 
            credentialsId: params.awsCredentials, 
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
              sh "HOME=\$WORKSPACE ansible-playbook -vvvvv roles/${role}/site.yml"
          }
        }
      }
    }
  }

  stage('Run Roles') {
        when {
        // Only run if modulesToRun has any values
        expression { modulesToRun }
    }
    def modulesDefined = readYaml file: 'modules-defined.yml'
    modulesDefinedList = modulesDefined['modulesDefined']

    for (mod in modulesToRun) {
      if (modulesDefinedList.contains(mod)){
        // Module is defined, run it
        echo "Playing terraform module ${role}"
        docker.image(params.terraformImage).inside("-e ANSIBLE_ROLES_PATH='roles' -v /etc/passwd:/etc/passwd:ro" ) {

          sh "HOME=\$WORKSPACE ansible-galaxy -vvvvv install -p roles -r play/${role}/requirements.yml"
          sh "cp -ar play/${role} roles/"
          withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding', 
            credentialsId: params.awsCredentials, 
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
              sh "HOME=\$WORKSPACE ansible-playbook -vvvvv roles/${role}/site.yml"
          }
        }
      }
    }
  }
}
