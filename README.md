# Run kubernetes cluster
cd kube
## push cloudflare secrets
cmd: /cloudflare/secrets
you will probably need to create cmd for linux or used OS
## create namespace
cmd: kubectl apply -f namespace
## deploy application
cmd: kubectl apply -f .

