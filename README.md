# Ansible-Playbook for [k3s](https://github.com/rancher/k3s) with [Vagrant](https://github.com/hashicorp/vagrant)
K3s is a new lightweight Kubernetes engine from rancher. Altough it's very easy and fast to setup, it's even better to automate this using Ansible. Vagrant opens the possibility for creating clean virtual machines on the fly. Especially for testing or development purpose, this is a great toolchain. The playbooks following a modular approach and also includes [Helm package manager](https://helm.sh/).

## Requirements
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Vagrant](https://www.vagrantup.com/downloads.html)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Get started
Clone the repo (`git clone`) and open the root folder. Take a look at `vars.yml` if you want to disable some packages like rancher. Now run `vagrant up --provision` and wait a few minutes. 

## Ressources
Having all components enabled in `vars.yml`, it took about 2 minutes from scratch (i7 machine). Depending on your hardware and internet connection, maybe so more or less. The memory footprint is very low. Including rancher, the complete machine takes less than 400MB. 

## Configure and customize
### Global Ansible vars
Defined in `values.yml` and passed to vagrant using `ansible.extra_vars = "@vars.yml"`. 
The following variables defines which components got installed: 
```yml
install_rancher
install_helm
```
Additionally, you could override some other defaults: 

```yml
- cert_manager_namespace: kube-system
- rancher_namespace: cattle-system
```

### Vagrant configuration
`vagrant-config.yaml` can be used to change certain settings of the created VM like memory or cpu cores. The default settings should fit well on a average developer machine. Feel free to change them if required. 

### Change config files
For development purpose, I introduced two environment variables: 
```bash
VAGRANT_CONFIG_FILE=vagrant-config.yaml
ANSIBLE_CONFIG_FILE=vars.yml 
```
Using them, you can use different config files without tracking them to VCS. We suffix them `-dev`, e.g. `vars-dev.yml` and use `re-create-dev.sh`. This script destroys the (maybe existing) VM and provision a new one. Additionally, it sets `ANSIBLE_CONFIG_FILE=vars-dev.yml`. 
## FAQ
### Build failed with _error: no objects passed to apply_

### Can I use Rancher UI? 
Sadly no. I already tried this without success. You'll find a `rancher-playbook.yml` but k3s isn't full compatible yet. Altough I could make the UI itself running, some features like cattle doesn't work. Bug tickets like [#123](https://github.com/rancher/k3s/issues/123) [#69](https://github.com/rancher/k3s/issues/69) already exists. The latest development seems active, so it should be only a matter of time until this changes. For this reason, I leave the Rancher playbooks in our repo. 