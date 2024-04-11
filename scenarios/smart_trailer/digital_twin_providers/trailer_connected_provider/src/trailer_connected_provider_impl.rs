// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
// SPDX-License-Identifier: MIT

//! Module containing gRPC service implementation based on [`invehicle_stack_interfaces::digital_twin_get_provider.proto`].
//!
//! Provides a gRPC endpoint for determining if the trailer is connected.
use smart_trailer_interfaces::digital_twin_get_provider::v1::digital_twin_get_provider_server::DigitalTwinGetProvider;
use smart_trailer_interfaces::digital_twin_get_provider::v1::{GetRequest, GetResponse};
use tonic::{Request, Response, Status};

/// Base structure for the Trailer Connected Provider gRPC service.
#[derive(Default)]
pub struct TrailerConnectedProviderImpl {}

#[tonic::async_trait]
impl DigitalTwinGetProvider for TrailerConnectedProviderImpl {
    /// This function returns the value of "is_trailer_connected" property
    async fn get(&self, _request: Request<GetRequest>) -> Result<Response<GetResponse>, Status> {
        // For now, we assume that if this provider is active, the trailer is connected
        // To expand this use case, we could simulate the trailer being disconnected as well
        let get_response = GetResponse {
            property_value: true,
        };
        Ok(Response::new(get_response))
    }
}
