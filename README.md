# Ozone - The Docker Compose Project

👉 **Recommended:** Please refer to the [Ozone](https://github.com/ozone-his/ozone-distro) repository to try and run Ozone 👈

While is not the recommended way, developpers can also run Ozone directly from this project. See instructions below.

## (option 1) Try Ozone FOSS in Gitpod

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/ozone-his/ozone-docker)

It may take some time to setup Ozone for the first time, so hang tight :hourglass_flowing_sand:

When ready Gitpod will launch the tab for OpenMRS 3.

## (option 2) Try Ozone locally using the embedded Apache 2 proxy

| HIS Component     | URL                            | Username | Password |
|-------------------|--------------------------------|----------|----------|
| OpenMRS 3         | http://localhost/openmrs/spa  | admin    | Admin123 |
| OpenMRS Legacy UI | http://localhost/openmrs      | admin    | Admin123 |
| SENAITE           | http://localhost:8081/senaite | admin    | password |
| Odoo              | http://localhost:8069         | admin    | admin    |
| Superset          | http://localhost:8088         | admin    | password |
| OpenHIM           | http://localhost:9000/        |root@openhim.org | admin|
| OpenELIS          | https://localhost:8443/OpenELIS-Global/  | admin    | adminADMIN! |



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

