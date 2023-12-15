# Ozone - The Docker Compose Project

👉 **Recommended:** Please refer to the [Ozone](https://github.com/ozone-his/ozone-distro) repository to try and run Ozone 👈

While is not the recommended way, developpers can also run Ozone directly from this project. See instructions below.

## (option 1) Try Ozone FOSS in Gitpod

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/ozone-his/ozone-docker)

It may take some time to setup Ozone for the first time, so hang tight :hourglass_flowing_sand:

When ready Gitpod will launch the tab for OpenMRS 3.

## (option 2) Try Ozone locally using the embedded Apache 2 proxy

Clone the repo
```bash
git clone https://github.com/ozone-his/ozone-docker
cd ozone-docker
```

Build
```bash
scripts/mvnw clean package
```

Run
```bash
source target/go-to-scripts-dir.sh
./fetch-ozone-distro.sh 1.0.0-SNAPSHOT # Replace by the version of your choice
./start-demo.sh
```

## (option 3) Try Ozone locally assuming Traefik is running on the host


Clone
```bash
git clone https://github.com/ozone-his/ozone-docker
cd ozone-docker
```

Build
```bash
scripts/mvnw clean package
```

Run
```bash
source target/go-to-scripts-dir.sh
./fetch-ozone-distro.sh 1.0.0-SNAPSHOT # Replace by the version of your choice
export TRAEFIK="true"
./start-demo.sh
```

## Browse Ozone

Once complete, the startup script will output the URLs to access the services in the terminal.

For example:
![Access Ozone](./readme/browse.png)
Ozone FOSS requires you to log into each component separately.

💡 **Did you know?** Ozone Pro comes with single sign-on (SSO) and all its integration layer is secured with OAuth2.

