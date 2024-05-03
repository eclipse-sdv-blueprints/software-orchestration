// Copyright (c) Microsoft Corporation.
// Licensed under the Apache License 2.0 license.
// SPDX-License-Identifier: Apache-2.0

fn main() -> Result<(), Box<dyn std::error::Error>> {
    tonic_build::compile_protos("../interfaces/digital_twin_get_provider.proto")?;
    Ok(())
}
