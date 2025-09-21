import { Injectable } from '@angular/core';
//import { MAPBOX_API_KEY } from '../mapbox.config';
import {
  SecretsManagerClient,
  GetSecretValueCommand,
} from "@aws-sdk/client-secrets-manager";

@Injectable({ providedIn: 'root' })
export class MapboxService {
  private readonly baseUrl = 'https://api.mapbox.com/directions/v5/mapbox/driving';

  // Use this code snippet in your app.
// If you need more information about configurations or implementing the sample code, visit the AWS docs:
// https://docs.aws.amazon.com/sdk-for-javascript/v3/developer-guide/getting-started.html


async get_mapbox_key(){
  let response;

  const secret_name = "MAPBOXTOKEN";

  const client = new SecretsManagerClient({
    region: "us-east-2",
  });
  try {
    response = await client.send(
      new GetSecretValueCommand({
        SecretId: secret_name,
        VersionStage: "AWSCURRENT", // VersionStage defaults to AWSCURRENT if unspecified
      })
    );
  } catch (error) {
    // For a list of exceptions thrown, see
    // https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
    throw error;
  }

  return response.SecretString;
}
  
  

  async getRoute(start: [number, number], end: [number, number]): Promise<[number, number][]> {
    // Mapbox expects [lon,lat]
    let secretToken = await this.get_mapbox_key();
    let secretKey = secretToken?.replace('{"MAPBOX_API_KEY":"','').replace('"}','');

    console.log("secretKey = " + secretKey);
    const coords = `${start[1]},${start[0]};${end[1]},${end[0]}`;
    const url = `${this.baseUrl}/${coords}?geometries=geojson&access_token=${secretKey}`;
    console.log(url)
    const response = await fetch(url);
    if (!response.ok) throw new Error('Mapbox Directions API error');
    const data = await response.json();
    // Return array of [lat,lon]
    return data.routes[0].geometry.coordinates.map((c: number[]) => [c[1], c[0]]);
  }
}