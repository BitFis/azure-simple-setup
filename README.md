# Simple Web App

A simple web app demo using opentofu to describe the infrastructure.

Requirements:
- [Install OpenTofu](https://opentofu.org/docs/intro/install/)
- [Install azure cli]()
- Repo cloned

On windows you can use [chocolatey](https://chocolatey.org/install) to get the requirements in minutes:

```powershell
choco install opentofu azure-cli git
```

## Login to Azure

Login to the azure service.

```bash
# enforce use the browser to login
az config set core.enable_broker_on_windows=false
# login into the account
az login
```

Deploy environment. During running the command following inputs are required:

- **resource_group_name**, random name to identify the resource
- **location**, define the location to deploy from
`

## Deploy Example

Lets first initialize and get all dependencies for opentofu:

```
tofu init
```

Configure the app by copying and changing the values in `terraform.tfvars`

```
cp .\terraform.tfvars.example .\terraform.tfvars
```

Lets deploy the app

```
tofu apply
```

Following some examples for location/region can be used:

- `West Europe`

[this gist contains a whole list](https://gist.github.com/ausfestivus/04e55c7d80229069bf3bc75870630ec8).

For the resource group name, you can use `rg_example_app`, or what ever feels comftable for itentification.

## Access Deployed Webpage

Open the webpage with security token,

```
tofu output -raw sas_url_query_string
```