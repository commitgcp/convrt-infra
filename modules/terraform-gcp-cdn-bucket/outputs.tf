# Copyright (c) 2020 The DAML Authors. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

output "external_ip" {
  description = "The external IP assigned to the global fowarding rule."
  value       = google_compute_global_address.default.address
}

