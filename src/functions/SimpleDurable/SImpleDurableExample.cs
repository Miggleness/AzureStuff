using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using Microsoft.Azure.WebJobs.Extensions.Http;

namespace Durable1
{
    public class Class1
    {
        [FunctionName ("E1_HelloSequence_HttpStarter")]
        public async Task<HttpResponseMessage> Function1 (
            [HttpTrigger (AuthorizationLevel.Anonymous, "post")] HttpRequestMessage req, [OrchestrationClient] DurableOrchestrationClient starter)
        {
            var instanceId = await starter.StartNewAsync ("E1_HelloSequence", "");

            return starter.CreateCheckStatusResponse (req, instanceId);
        }

        [FunctionName ("E1_HelloSequence")]
        public async Task<List<string>> Run (
            [OrchestrationTrigger] DurableOrchestrationContext context)
        {
            var output = new List<string> ();

            output.Add (await context.CallActivityAsync<string> ("E1_SayHello", "Tokyo"));
            output.Add (await context.CallActivityAsync<string> ("E1_SayHello", "China"));
            output.Add (await context.CallActivityAsync<string> ("E1_SayHello", "Singapore"));

            return output;

        }

        [FunctionName ("E1_SayHello")]
        public string SayHello ([ActivityTrigger] DurableActivityContext context)
        {
            var who = context.GetInput<string> ();
            return $"Hello there, {who}";
        }

    }
}