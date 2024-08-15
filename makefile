
.PHONY: plan apply destory documentation check-security shell format lint format prep
ENV=dev
SUBFOLDER=.
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
	@docker-compose run --rm build terraform init
	@echo "$(BOLD)Switching to workspace $(WORKSPACE)$(RESET)"
	@docker-compose run --rm build terraform workspace select $(WORKSPACE) || terraform workspace new $(WORKSPACE)
	
format: prep ## Rewrites all Terraform configuration files to a canonical format.
	@docker-compose run --rm build terraform fmt -write=true -recursive

lint: prep ## Check for possible errors best practices
	@docker-compose run --rm build tflint

shell: ## Grants shell access to the Docker image for debugging
	@docker-compose run --rm build /bin/bash

check-security: prep ## Static analysis of your terraform templates to spot potential security issues.
	@docker-compose run --rm build tfsec .

documentation: prep ## Generate README.md 
	@docker-compose run --rm build terraform-docs markdown table --output-file README.md --output-mode inject . 

plan: prep ## Show deployment plan
	@docker-compose run --rm build terraform plan -var-file="$(VARS)" 

apply: prep ## Deploy resources
	@docker-compose run --rm build terraform apply -var-file="$(VARS)"

destroy: prep ## Destroy resources
	@docker-compose run --rm build terraform destroy -var-file="$(VARS)"