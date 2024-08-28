output "redis_endpoint" {
  value = "redis://${aws_elasticache_cluster.redis_cluster.cache_nodes[0].address}:${aws_elasticache_cluster.redis_cluster.port}"
  description = "The endpoint of the Redis cluster"
}