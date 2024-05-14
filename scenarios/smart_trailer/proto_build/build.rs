// Copyright (c) Microsoft Corporation.
// Licensed under the Apache License, Version 2.0.
// SPDX-License-Identifier: Apache-2.0

fn main() -> Result<(), Box<dyn std::error::Error>> {
    tonic_build::configure()
        .message_attribute(
            "EndpointInfo",
            "#[derive(serde::Deserialize, serde::Serialize)]",
        )
        .message_attribute(
            "EntityAccessInfo",
            "#[derive(serde::Deserialize, serde::Serialize)]",
        )
        .compile(
            &["../interfaces/invehicle_digital_twin/v1/invehicle_digital_twin.proto"],
            &["../interfaces/invehicle_digital_twin/v1/"],
        )?;
    tonic_build::configure()
        .message_attribute(
            "Constraint",
            "#[derive(serde::Deserialize, serde::Serialize)]",
        )
        .message_attribute(
            "CallbackPayload",
            "#[derive(serde::Deserialize, serde::Serialize)]",
        )
        .message_attribute(
            "SubscriptionInfo",
            "#[derive(serde::Deserialize, serde::Serialize)]",
        )
        .compile(
            &["../interfaces/module/managed_subscribe/v1/managed_subscribe.proto"],
            &["../interfaces/module/managed_subscribe/v1/"],
        )?;
    tonic_build::configure().compile(
        &["../interfaces/service_discovery/v1/service_registry.proto"],
        &["../interfaces/service_discovery/v1/"],
    )?;

    Ok(())
}
