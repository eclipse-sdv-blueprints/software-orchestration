// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
// SPDX-License-Identifier: MIT

fn main() -> Result<(), Box<dyn std::error::Error>> {
    tonic_build::compile_protos("../interfaces/digital_twin_get_provider.proto")?;
    Ok(())
}
