# Terraform & Ansible CI/CD Pipeline

This repository contains an automated CI/CD pipeline that combines Terraform infrastructure provisioning with Ansible configuration management.

## Pipeline Overview

The pipeline consists of two main jobs:

1. **Terraform Job**: Creates and manages AWS infrastructure
2. **Ansible Job**: Configures the created instances using dynamic inventory

## Workflow Features

### 🔄 Automated Infrastructure Provisioning
- **Terraform**: Creates EC2 instances, VPC, subnets, and other AWS resources
- **Environment Support**: Supports both `pre-prod` and `prod` environments
- **Auto-approval**: Automatically applies changes on push to protected branches

### 🎯 Dynamic Ansible Inventory
- **Automatic Generation**: Creates Ansible inventory from Terraform outputs
- **Real-time Updates**: Inventory is generated fresh for each deployment
- **Multi-node Support**: Supports control plane and worker node configurations

### 🔐 Secure SSH Access
- **Key Management**: Uses GitHub Secrets for SSH private key storage
- **Connection Validation**: Waits for SSH to be available before running Ansible
- **Automatic Cleanup**: Removes SSH keys after deployment

## Required GitHub Secrets

Configure these secrets in your GitHub repository settings:

```bash
AWS_ACCESS_KEY_ID          # Your AWS access key
AWS_SECRET_ACCESS_KEY      # Your AWS secret key
SSH_PRIVATE_KEY           # Private SSH key for instance access
```

## Pipeline Structure

```
.github/workflows/terraform.yml
├── terraform job
│   ├── Checkout repository
│   ├── Setup Terraform
│   ├── Set Environment Path
│   ├── Terraform Init
│   ├── Terraform Validate
│   ├── Terraform Plan
│   ├── Terraform Apply
│   └── Get Terraform Outputs (base64 encoded)
└── ansible job
    ├── Checkout repository
    ├── Setup Terraform Outputs (decoded)
    ├── Setup Python & Install Ansible
    ├── Generate Dynamic Inventory
    ├── Setup SSH Key
    ├── Wait for SSH to be available
    ├── Run Ansible Playbook
    └── Cleanup SSH Key
```

## Ansible Scripts

### `ansible/generate_inventory.py`
Generates dynamic Ansible inventory from Terraform outputs.

**Features:**
- Reads Terraform JSON outputs
- Creates inventory with control plane and worker groups
- Configures SSH connection parameters
- Handles multiple instances automatically

**Usage:**
```bash
python ansible/generate_inventory.py terraform_outputs.json dynamic_inventory.yml
```

### `ansible/wait_for_ssh.py`
Waits for SSH to be available on all instances.

**Features:**
- Checks SSH connectivity to all instances
- Configurable timeout and retry intervals
- Progress reporting
- Graceful error handling

**Usage:**
```bash
python ansible/wait_for_ssh.py terraform_outputs.json
```

## Terraform Outputs

The pipeline expects these Terraform outputs:

```hcl
output "ec2_public_ips" {
  description = "Public IP addresses of the EC2 instances."
  value       = module.compute.public_ips
}

output "ec2_private_ips" {
  description = "Private IP addresses of the EC2 instances."
  value       = module.compute.private_ips
}
```

## Ansible Inventory Structure

The generated inventory follows this structure:

```yaml
all:
  children:
    controlplane:
      hosts:
        cp1:
          ansible_host: <public_ip>
          private_ip: <private_ip>
          ansible_user: ubuntu
          ansible_ssh_private_key_file: ~/.ssh/id_rsa
    worker:
      hosts:
        worker1:
          ansible_host: <public_ip>
          private_ip: <private_ip>
          ansible_user: ubuntu
          ansible_ssh_private_key_file: ~/.ssh/id_rsa
```

## Deployment Process

1. **Push to Branch**: Push changes to `pre-prod` or `prod` branch
2. **Terraform Execution**: 
   - Initializes Terraform
   - Validates configuration
   - Plans changes
   - Applies infrastructure
   - Captures outputs
3. **Ansible Execution**:
   - Decodes Terraform outputs
   - Generates dynamic inventory
   - Sets up SSH access
   - Waits for instances to be ready
   - Runs Ansible playbooks
   - Cleans up SSH keys

## Environment Variables

The pipeline automatically sets the correct Terraform directory based on the branch:

- `pre-prod` branch → `envs/pre-prod`
- `prod` branch → `envs/prod`

## Troubleshooting

### Common Issues

1. **SSH Connection Failed**
   - Verify SSH private key is correctly set in GitHub secrets
   - Check security group allows SSH access (port 22)
   - Ensure instances are fully booted

2. **Terraform Outputs Missing**
   - Verify Terraform modules output the required values
   - Check that the apply step completed successfully

3. **Ansible Playbook Failed**
   - Check generated inventory file
   - Verify SSH connectivity to instances
   - Review Ansible playbook syntax and roles

### Debug Steps

1. Check GitHub Actions logs for detailed error messages
2. Verify Terraform outputs are correctly captured
3. Test SSH connectivity manually if needed
4. Review generated inventory file structure

## Security Considerations

- SSH private keys are automatically cleaned up after deployment
- Terraform outputs are base64 encoded for secure transmission
- All sensitive data is stored in GitHub Secrets
- SSH connections use strict security options

## Customization

### Adding New Environments

1. Create new environment directory in `envs/`
2. Add branch name to workflow triggers
3. Update environment path logic if needed

### Modifying Ansible Configuration

1. Update `ansible/playbook.yml` for new roles/tasks
2. Modify `ansible/generate_inventory.py` for different inventory structure
3. Adjust SSH wait parameters in `ansible/wait_for_ssh.py`

### Extending Terraform Outputs

1. Add new outputs to Terraform modules
2. Update `ansible/generate_inventory.py` to use new outputs
3. Modify inventory generation logic as needed 