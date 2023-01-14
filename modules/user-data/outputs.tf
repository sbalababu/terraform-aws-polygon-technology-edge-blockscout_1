output "polygon_edge_node" {
  value       = data.cloudinit_config.blockscout.rendered
  description = "Base64 rendered polygon edge node user-init data"
}