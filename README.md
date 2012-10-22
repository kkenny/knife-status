knife-status
============

A Chef Knife plugin to view the status of the last chef-client execution for a node.knife-inventory

## Place the files

Copy these files to the plugin directory of your chef installation.

You could also symlink the files in this repo, or simply specify this repo as a place to look for plugins in your knife configuration

## Usage

```
knife node status NODE
knife environment status CHEF_ENVIRONMENT
```
