# Forge VM

The latest version is [`forge-vm-021325.zip`](https://cs.brown.edu/~tbn/files/forge-vm-021325.zip).

While we still suggest a normal installation, it is possible that some prospective users will have issues (e.g., with Racket, Java, lack access to install applications, etc). To help run Forge in these situations, we have created a VM image. (This reduces potential snags with visualization-in-browser that might be seen in a Docker container.)

This document contains instructions on downloading and running the Forge VM. **The VM is only for x64 architectures, not Apple Silicon.** If you need a VM for Apple chips, please contact us.

## VirtualBox 

There are a few VM hypervisor options out there. We used [VirtualBox](https://www.virtualbox.org) because of the low learning curve and not needing to sign up for any accounts to download it.

## The Image 

The image is an Ubuntu 24.04.1 LTS machine. We distribute it as a zipfile; the uncompressed image is 10 GB. The user name is `forge`, and its password is `forge`. 

The install _Brave_ as its browser, not Firefox. This is because of various issues we have seen with Firefox and temporary files on 24.04.1. 

We've pre-installed Racket 8.15, Java, and Forge via `git`. The Forge repo is off the `forge` user's main directory, in a folder named `Forge`. Since the goal of this VM is as a fallback, we have _not_ installed VSCode. 

## Testing the Image 

From the user's home directory, run `racket Forge/forge/examples/lights_puzzle/ring_of_lights.frg`. The browser should open. Click "Run" and you should see a ring of lights instance. 

## Updating Forge 

Navigate to the `Forge` folder inside the user's home directory. Run `git pull` to pull the latest `main` branch update, and then run `raco setup forge` to recompile the new version of Forge. 






