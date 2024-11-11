#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { GrafanaStack } from '../lib/grafana-stack';
import * as dotenv from 'dotenv';

dotenv.config();

export type ConfigProps = {
  TEAM_ID: string;
  MASTER_ROLE: string;
  PROMETHEUS_HOST: string;
  PROMETHEUS_USERNAME: string;
  PROMETHEUS_PASSWORD: string;
  LOKI_HOST: string;
  LOKI_USERNAME: string;
  LOKI_PASSWORD: string;
  TEMPO_HOST: string;
  TEMPO_USERNAME: string;
  TEMPO_PASSWORD: string;
};

export const getConfig = (): ConfigProps => ({
  TEAM_ID: process.env.TEAM_ID || `unknown`,
  MASTER_ROLE: process.env.MASTER_ROLE || `unknown`,
  PROMETHEUS_HOST: process.env.PROMETHEUS_HOST || `unknown`,
  PROMETHEUS_USERNAME: process.env.PROMETHEUS_USERNAME || `unknown`,
  PROMETHEUS_PASSWORD: process.env.PROMETHEUS_PASSWORD || `unknown`,
  LOKI_HOST: process.env.LOKI_HOST || `unknown`,
  LOKI_USERNAME: process.env.LOKI_USERNAME || `unknown`,
  LOKI_PASSWORD: process.env.LOKI_PASSWORD || `unknown`,
  TEMPO_HOST: process.env.TEMPO_HOST || `unknown`,
  TEMPO_USERNAME: process.env.TEMPO_USERNAME || `unknown`,
  TEMPO_PASSWORD: process.env.TEMPO_PASSWORD || `unknown`,
});

const config = getConfig();
console.log(config);


const app = new cdk.App();
new GrafanaStack(
  app, 
  config.TEAM_ID, 
  config.MASTER_ROLE, 
  config.PROMETHEUS_HOST, 
  config.PROMETHEUS_USERNAME, 
  config.PROMETHEUS_PASSWORD,
  config.LOKI_HOST, 
  config.LOKI_USERNAME, 
  config.LOKI_PASSWORD,
  config.TEMPO_HOST, 
  config.TEMPO_USERNAME, 
  config.TEMPO_PASSWORD,
  false);