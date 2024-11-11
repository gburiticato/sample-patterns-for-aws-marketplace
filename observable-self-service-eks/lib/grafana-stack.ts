import * as cdk from "aws-cdk-lib";
import * as ec2 from "aws-cdk-lib/aws-ec2";
import * as eks from "aws-cdk-lib/aws-eks";
import * as iam from "aws-cdk-lib/aws-iam";
import { KubectlV28Layer } from '@aws-cdk/lambda-layer-kubectl-v28'

export class GrafanaStack extends cdk.Stack {
  constructor(
    scope: cdk.App,
    id: string,
    kubernetesRole: string,
    prometheusHost: string,
    prometheusUsername: string,
    prometheusPassword: string,
    lokiHost: string,
    lokiUsername: string,
    lokiPassword: string,
    tempoHost: string,
    tempoUsername: string,
    tempoPassword: string,
    createVPC: boolean,
    props?: cdk.StackProps,
    vpcID?: string) {
    super(scope, id, props);

    var vpc: cdk.aws_ec2.IVpc | cdk.aws_ec2.Vpc;

    if (createVPC && vpcID) {
      console.log(`Looking up vpc with ID ${vpcID}`)
      vpc = ec2.Vpc.fromLookup(this, `${id}-vpc`, {
        vpcId: vpcID
      }
      )
    } else {
      console.log(`Creating new vpc`)
      vpc = new ec2.Vpc(this, `${id}-vpc`)
    }

    const eksCluster = new eks.Cluster(this, `${id}-eks`, {
      vpc: vpc,
      defaultCapacity: 0,
      version: eks.KubernetesVersion.V1_29,
      kubectlLayer: new KubectlV28Layer(this, "kubectl"),
      ipFamily: eks.IpFamily.IP_V4,
      clusterLogging: [
        eks.ClusterLoggingTypes.AUDIT,
      ],
      outputClusterName: true,
      outputConfigCommand: true,
      authenticationMode: eks.AuthenticationMode.API_AND_CONFIG_MAP,
    });

    const userRole = iam.Role.fromRoleArn(this, "Role", kubernetesRole);
    const clusterMasterRole = eksCluster.adminRole;

    userRole.grantAssumeRole(clusterMasterRole);

    eksCluster.addNodegroupCapacity(`${id}-eks-nodegroup`, {
      amiType: eks.NodegroupAmiType.AL2_X86_64,
      instanceTypes: [new ec2.InstanceType("m5.large")],
      desiredSize: 2,
      diskSize: 20,
      nodeRole: new iam.Role(this, "eksClusterNodeGroupRole", {
        roleName: "eksClusterNodeGroupRole",
        assumedBy: new iam.ServicePrincipal("ec2.amazonaws.com"),
        managedPolicies: [
          iam.ManagedPolicy.fromAwsManagedPolicyName("AmazonEKSWorkerNodePolicy"),
          iam.ManagedPolicy.fromAwsManagedPolicyName("AmazonEC2ContainerRegistryReadOnly"),
          iam.ManagedPolicy.fromAwsManagedPolicyName("AmazonEKS_CNI_Policy"),
        ],
      }),
    });

    const kubeProxy = new eks.Addon(this, "addonKubeProxy", {
      addonName: "kube-proxy",
      cluster: eksCluster,
    });

    const coreDns = new eks.Addon(this, "addonCoreDns", {
      addonName: "coredns",
      cluster: eksCluster,
    });

    const vpcCni = new eks.Addon(this, "addonVpcCni", {
      addonName: "vpc-cni",
      cluster: eksCluster,
    });

    const grafanaSecret = eksCluster.addManifest('grafana-secret', {
      apiVersion: 'v1',
        kind: 'Secret',
        metadata: {
          name: 'grafana-cloud',
          namespace: 'monitoring',
        },
        stringData: {
          "prometheus-host": `https://${prometheusHost}.grafana.net`,
          "prometheus-username": `${prometheusUsername}`,
          "prometheus-password": `${prometheusPassword}`,
          "loki-host": `https://${lokiHost}.grafana.net`,
          "loki-username": `${lokiUsername}`,
          "loki-password": `${lokiPassword}`,
          "tempo-host": `https://${tempoHost}.grafana.net`,
          "tempo-username": `${tempoUsername}`,
          "tempo-password": `${tempoPassword}`,
        }
    })

    const grafanaAddOn = new eks.Addon(this, "addonGrafana", {
      addonName: "grafana-labs_kubernetes-monitoring",
      cluster: eksCluster,
    });
  }
}
