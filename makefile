
.PHONY: apply destroy-backend destroy destroy-target plan-destroy plan plan-target prep
VARS="./$(ENV).tfvars"
CURRENT_FOLDER=$(shell basename "$$(pwd)")
WORKSPACE="$(ENV)"
BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
RESET=$(shell tput sgr0)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

set-env:
	@if [ -z $(ENV) ]; then \
		echo "$(BOLD)$(RED)ENV was not set$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ ! -z $${ERROR} ] && [ $${ERROR} -eq 1 ]; then \
		echo "$(BOLD)Example usage: \`AWS_PROFILE=whatever ENV=demo REGION=us-east-2 make plan\`$(RESET)"; \
		exit 1; \
	 fi
	@if [ ! -f "$(VARS)" ]; then \
		echo "$(BOLD)$(RED)Could not find variables file: $(VARS)$(RESET)"; \
		exit 1; \
	 fi

prep: set-env
	@terraform init
	@echo "$(BOLD)Switching to workspace $(WORKSPACE)$(RESET)"
	@terraform workspace select $(WORKSPACE) || terraform workspace new $(WORKSPACE)

format: prep ## Rewrites all Terraform configuration files to a canonical format.
	@terraform fmt -write=true -recursive

# https://github.com/terraform-linters/tflint
lint: prep ## Check for possible errors best practices
	@tflint

# https://github.com/liamg/tfsec
check-security: prep ## Static analysis of your terraform templates to spot potential security issues.
	@tfsec .

documentation: prep ## Generate README.md 
	@terraform-docs markdown table --sort-by-required  . > README.md

plan: prep ## Show deployment plan
	terraform plan \
		-var-file="$(VARS)" 

apply: prep ## Deploy resources
	@terraform apply \
		-var-file="$(VARS)"

destroy: prep ## Destroy resources
	@terraform destroy \
		-var-file="$(VARS)"