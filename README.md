Sign in as a service principal:
`az login --service-principal -u <app-id> -p <password-or-cert> --tenant <tenant>`

Get a secret:
`az keyvault secret show --vault-name github-keyvault-kv --name my-secret --query value --output tsv`
