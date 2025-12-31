{ pkgs, ... }:

{
  # Enable K3s
  services.k3s.enable = true;
  services.k3s.role = "server";

  # Install kubectl
  environment.systemPackages = with pkgs; [
    kubectl
    k9s
  ];

  # Allow kubectl access
  environment.variables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
}
