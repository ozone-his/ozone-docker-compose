# Ozone - The Docker Compose Project

>_The entreprise-grade health information system that augments OpenMRS 3._

This is the official Docker Compose project for the free and open-source software flavour of Ozone, aka **Ozone FOSS**.
This Docker Compose project makes it easy to start and run an Ozone FOSS server on the infrastructure of your choice.

:bulb: **Did you know?** There is a *pro* flavour of Ozone, aka **Ozone Pro**, that adds a number of entreprise features to Ozone FOSS.

## 1. Quick start

### Run Ozone FOSS locally
Type in the following in a terminal:

```bash
git clone https://github.com/ozone-his/ozone-docker
cd ozone-docker
# Create the web network if it does not exist.
# The project is configured to run behind Traefik running in the web network but the demo uses Apache
# So you have to create this network for docker compose to work.
# For running behind Traefik see the manual instractions.
docker network create web
./start-demo.sh
```

It may take some time to download and setup Ozone for the first time, so hang tight :hourglass_flowing_sand:

Then [start browsing](#2-browse-ozone) Ozone.

#### :warning: Troubleshooting Ozone quick start locally?
If you experience issues with the quick start script? → Try the [manual setup](readme/manual-setup.md) instead.

### Run Ozone FOSS in Gitpod
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/ozone-his/ozone-docker)

It may take some time to download and setup Ozone for the first time, so hang tight :hourglass_flowing_sand:

When ready Gitpod will launch the tab for OpenMRS 3.

## 2. Browse Ozone
Ozone FOSS requires you to log into each component separately:

| HIS Component     | URL                            | Username | Password |
|-------------------|--------------------------------|----------|----------|
| OpenMRS 3         | http://localhost/openmrs/spa  | admin    | Admin123 |
| OpenMRS Legacy UI | http://localhost/openmrs      | admin    | Admin123 |
| SENAITE           | http://localhost:8081/senaite | admin    | password |
| Odoo              | http://localhost:8069         | admin    | admin    |
| Superset          | http://localhost:8088         | admin    | password |

If you followed the manual Steps and started the Project with Traefik the coordinates for the components will be different.
For macOS replace 172-17-0-1 with your host IP. For example if your host IP is 192.168.200.197 replace with 192-168-200-197

| HIS Component     | URL                            | Username | Password |
|-------------------|--------------------------------|----------|----------|
| OpenMRS 3         | htts://emr-172-17-0-1.traefik.me  | admin    | Admin123 |
| OpenMRS Legacy UI | htts://emr-172-17-0-1.traefik.me/openmrs   | admin    | Admin123 |
| SENAITE           | htts://lims-172-17-0-1.traefik.me | admin    | password |
| Odoo              | htts://erp-172-17-0-1.traefik.me       | admin    | admin    |
| Superset          | htts://analytics-172-17-0-1.traefik.me       | admin    | password |

:bulb: **Did you know?** Ozone Pro comes with single sign-on (SSO) and all its integration layer is secured with OAuth2.

## 3. Analytics in Ozone FOSS
There is a number of manual steps required to refresh analytics data in Ozone FOSS, please follow [this](readme/analytics.md) guide to know more.

:bulb: **Did you know?** Ozone Pro embeds a service called *Ozone Analytics* that streams data from all its components automatically and in real-time to any reporting and BI platform.

## 4. Find us
[Slack](https://openmrs.slack.com/archives/C02PYQD5D0A) - [Forum](https://talk.openmrs.org/c/software/ozone-his) - [Website](http://ozone-his.com)

<sub>:information_source: Self sign-up [here](https://slack.openmrs.org/) before accessing our Slack space for the first time.</sub>
## 5. Report an issue
1. Either start a conversation on [Slack](https://openmrs.slack.com/archives/C02PYQD5D0A) about it,
1. Or start a thread on our [forum](https://talk.openmrs.org/c/software/ozone-his) about it.
