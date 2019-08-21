export TF_VAR_backend_bucket := $(backend_bucket)

.PHONY: check apply plan validate init
check:
ifeq ($(strip $(backend_bucket)),)
	@echo "backend_bucket must be provided"
	@exit 1
endif
ifeq ($(strip $(TF_VAR_appenv)),)
	@echo "TF_VAR_appenv must be provided"
	@exit 1
else
	@echo "appenv: $(TF_VAR_appenv)"
endif
ifeq ($(strip $(backend_key)),)
	@echo "backend_key must be provided"
	@exit 1
endif

apply: plan
	terraform apply --auto-approve

plan: validate
	terraform plan

validate: init
	terraform validate
	terrascan --location . --tests all

init: check
	terraform init -backend-config="bucket=$(backend_bucket)" -backend-config="key=$(backend_key)"