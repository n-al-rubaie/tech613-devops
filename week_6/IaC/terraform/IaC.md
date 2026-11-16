# Intro to Infrastructure as Code

## What problem needs solving?

* At the moment, we are still "provisioning" servers.

What is "provisioning" servers?
* The process of setting up and configuring servers.

## What have we automated?

* VMs
  * Creation of the VMs? No
  * Creation of the infrastructure they live in? No
  * Setup and configuring of the software on them? Yes, how?
    * Bash scripting
    * User data
    * Images

* What if we could automate all of it?
* What if we codify all of it so that:
  * We do NOT define how to get it done (imperative, like our bash scripts).
  * We define the desired state/outcome (and the tool takes care of working out the steps to get us there).


## Solving the problem

Infrastructure as Code (IaC) can do all the provisioning of:

* The infrastructure itself (the servers & the network & extra resources)
* Configuring the servers i.e. installing the correct software and configuring the settings

... in an automated and repeatable manner using code.

The process typically involves:

1. Creating the server instance
2. Configuring OS and software
3. Deploying application
4. Configuring monitoring and logging

<br>

### What is IaC?

* A way to manage and provision computers through machine-readable definitions of infrastructure and software configurations.

### Benefits of IaC?

* Speed and simplicity
  * Less manually checking that everything ended up the way it should be, because you are describing the end state required and trusting the tool to work out how to get it done.
* Consistency & accuracy
  * Less risk of human error.
* Version control
* Scalability
  * Easily re-use code, easily scale or duplicate infrastructure.

### When/where to use IaC

* Question is: When do you automate something? Ask yourself: Is it worth the investment in time?
* Often used in CI/CD pipelines.

### What are the tools available for IaC?

2 types of tools:

* Configuration management tools (about configuring software)
  * Chef
  * Puppet
  * Ansible

* Orchestration tools (orchestration of infrastructure)
  * CloudFormation (AWS)
  * ARM/Bicep templates (Azure)
  * Terraform
  * Ansible (can also do this, but not primarily designed for this)




# Terraform vs Ansible

| Terraform | Ansible |
|------------|---------|
| Creates and manages infrastructure | Configures software on servers |
| Infrastructure as Code (IaC) | Configuration Management |
| Creates resources like AWS EC2, VPCs, and S3 buckets | Installs software like Nginx, Docker, and Apache |
| Uses `.tf` files | Uses YAML playbooks |
| Focuses on **what to build** | Focuses on **how to configure it** |

## Easy Way to Remember

### Terraform = Build the House 
- Create VM
- Create network
- Create storage

### Ansible = Furnish the House 
- Install software
- Create users
- Configure services

## Example

**Terraform**
```text
Create an AWS EC2 server
```

**Ansible**
```text
Install Nginx on that EC2 server
```

## Common Workflow

```text
Terraform → Creates the infrastructure
        ↓
Ansible → Configures the infrastructure
```

