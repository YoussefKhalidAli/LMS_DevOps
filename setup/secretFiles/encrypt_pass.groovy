import hudson.util.Secret

def secret = Secret.fromString("dockerhub_password")
println(secret.getEncryptedValue())