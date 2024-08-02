#r "Newtonsoft.Json"

using System;
using System.Net; 
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Primitives;
using Newtonsoft.Json;
using Azure.Storage;
using Azure.Storage.Blobs; 

public static StorageSharedKeyCredential GetCreds() {
    string accountName = "<storageAccountName>";
    string accountKey = "<accountKey>";
    return new StorageSharedKeyCredential(accountName, accountKey);
}

public static BlobServiceClient CreateBlobClient() {
    string accountName = "<storageAccountName>";

    return new BlobServiceClient(
        new Uri($"https://{accountName}.blob.core.windows.net"),
        GetCreds());
}

class Response
{
  public string token = "red";
  public string url = "red";
}

public static async Task<IActionResult> Run(HttpRequest req, ILogger log)
{
    log.LogInformation("Request to create SAS for blob storage.");

    // pass firebase access token via query 
    string token = req.Query["token"];

    // pass firebase access token alternatively via json body
    string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
    dynamic data = JsonConvert.DeserializeObject(requestBody);
    token = token ?? data?.token;

    dynamic blobClient = CreateBlobClient();

    Azure.Storage.Sas.BlobSasBuilder blobSasBuilder = new Azure.Storage.Sas.BlobSasBuilder()
    {
        BlobContainerName = "app",
        ExpiresOn = DateTime.UtcNow.AddMinutes(8640),//Let SAS token expire after 5 minutes.
        Protocol = Azure.Storage.Sas.SasProtocol.Https,
    };
    blobSasBuilder.SetPermissions(Azure.Storage.Sas.BlobSasPermissions.Read);

    dynamic res = new Response();

    res.token = blobSasBuilder.ToSasQueryParameters(GetCreds()).ToString();
    res.url = blobClient.Uri.AbsoluteUri + "app/index.html" + "?" + res.token;

    string responseMessage = string.IsNullOrEmpty(token)
        ? "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."
                : $"Hello, {token}. This HTTP triggered function executed successfully.";

    responseMessage = JsonConvert.SerializeObject(res);
    // string responseMessage = $"\{\"token\": \"{sasToken}\", \"url\": \"{sasUrl}\"\}"
    // responseMessage = JsonConvert.SerializeObject(product);

    return new OkObjectResult(responseMessage);
}