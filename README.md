# Ozone - The Docker Compose Project

>_The entreprise-grade health information system that augments OpenMRS 3._

This is the official Docker Compose project to start and run an Ozone FOSS server.

## 1. Quick start
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
In its FOSS version Ozone requires you to log into each component separately:

| HIS Component     | URL                            | Username | Password |
|-------------------|--------------------------------|----------|----------|
| OpenMRS 3         | http://172.17.0.1/openmrs/spa  | admin    | Admin123 |
| OpenMRS Legacy UI | http://172.17.0.1/openmrs      | admin    | Admin123 |
| SENAITE           | http://172.17.0.1:8081/senaite | admin    | admin    |
| Odoo              | http://172.17.0.1:8069         | admin    | admin    |
| Superset          | http://172.17.0.1:8088         | admin    | password |

## 3. Analytics in Ozone FOSS
One of the biggest differences between Ozone FOSS and Ozone Pro lies in that Ozone FOSS does **not** stream data in real-time to its BI tool, Superset. There is a number of manual steps required to refresh analytics data in Ozone FOSS, please follow [this](readme/analytics.md) guide to know more.

## 4. Find us
[Slack](https://openmrs.slack.com/archives/C02PYQD5D0A) - [Forum](https://talk.openmrs.org/c/software/ozone-his) - [Website](http://ozone-his.com)

<sub>:information_source: Self sign-up [here](https://slack.openmrs.org/) before accessing our Slack space for the first time.</sub>
## 5. Report an issue
1. Either start a conversation on Slack about it,
1. Or start a thread on our forum about it.