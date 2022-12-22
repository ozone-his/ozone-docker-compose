# Ozone - The Docker Compose Project

>_The entreprise-grade health information system that augments OpenMRS 3._

This is the official Docker Compose project for the free and open-source software flavour of Ozone, aka **Ozone FOSS**.
This Docker Compose project makes it easy to start and run an Ozone FOSS server on the infrastructure of your choice.

:bulb: **Did you know?** There is a *pro* flavour of Ozone, aka **Ozone Pro**, that adds a number of entreprise features to Ozone FOSS.

## 1. Quick start
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/ozone-his/ozone-docker)

```
$ git clone https://github.com/ozone-his/ozone-docker
$ cd ozone-docker
$ ./start-demo.sh
```
It may take some time to download and setup Ozone for the first time, so hang tight :hourglass_flowing_sand:

Then [start browsing](#2-browse-ozone) Ozone.

#### :warning: Troubleshooting Ozone quick start
Are you experiencing issues with the quick start script? → Try the [manual setup](readme/manual-setup.md) instead.

## 2. Browse Ozone
Ozone FOSS requires you to log into each component separately:

| HIS Component     | URL                            | Username | Password |
|-------------------|--------------------------------|----------|----------|
| OpenMRS 3         | http://172.17.0.1/openmrs/spa  | admin    | Admin123 |
| OpenMRS Legacy UI | http://172.17.0.1/openmrs      | admin    | Admin123 |
| SENAITE           | http://172.17.0.1:8081/senaite | admin    | admin    |
| Odoo              | http://172.17.0.1:8069         | admin    | admin    |
| Superset          | http://172.17.0.1:8088         | admin    | password |

:bulb: **Did you know?** Ozone Pro comes with single sign-on (SSO) and all its integration layer is secured with OAuth2.

## 3. Analytics in Ozone FOSS
There is a number of manual steps required to refresh analytics data in Ozone FOSS, please follow [this](readme/analytics.md) guide to know more.

:bulb: **Did you know?** Ozone Pro embeds a service named *Ozone Analytics* that streams data from all its components automatically and in real-time data to any reporting and BI platform.

## 4. Find us
[Slack](https://openmrs.slack.com/archives/C02PYQD5D0A) - [Forum](https://talk.openmrs.org/c/software/ozone-his) - [Website](http://ozone-his.com)

<sub>:information_source: Self sign-up [here](https://slack.openmrs.org/) before accessing our Slack space for the first time.</sub>
## 5. Report an issue
1. Either start a conversation on [Slack](https://openmrs.slack.com/archives/C02PYQD5D0A) about it,
1. Or start a thread on our [forum](https://talk.openmrs.org/c/software/ozone-his) about it.
