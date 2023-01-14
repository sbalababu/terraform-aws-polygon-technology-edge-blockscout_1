resource "aws_iam_role_policy" "polygon_edge_node" {
  name_prefix = "polygon-edge-node-"
  role        = aws_iam_role.polygon_edge_node.id

  policy = data.aws_iam_policy_document.polygon_edge_node.json
}
resource "aws_iam_role" "polygon_edge_node" {
  name_prefix = "polygon-edge-node-"

  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json

}

resource "aws_iam_role_policy_attachment" "ssm_role_policy_attach" {
  role       = aws_iam_role.polygon_edge_node.name
  policy_arn = data.aws_iam_policy.amazon_ssm_managed_instance_core.arn
}

resource "aws_iam_instance_profile" "polygon_edge_node" {
  name_prefix = "polygon-edge-node-"
  role        = aws_iam_role.polygon_edge_node.name
}

/*
resource "aws_iam_role_policy" "bs_polygon_edge_node" {
  name_prefix = "bs_polygon-edge-node-"
  role        = aws_iam_role.bs_polygon_edge_node.id

  policy = data.aws_iam_policy_document.bs_polygon_edge_node.json
}
resource "aws_iam_role" "bs_polygon_edge_node" {
  name_prefix = "bs_polygon-edge-node-"

  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json

}

resource "aws_iam_role_policy_attachment" "ssm_role_policy_attach" {
  role       = aws_iam_role.bs_polygon_edge_node.name
  policy_arn = data.aws_iam_policy.amazon_ssm_managed_instance_core.arn
}

resource "aws_iam_instance_profile" "bs_polygon_edge_node" {
  name_prefix = "bs_polygon-edge-node-"
  role        = aws_iam_role.bs_polygon_edge_node.name
}
*/
