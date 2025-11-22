# Serverless Contact Form – Proxy & Non-Proxy API Gateway Implementation
---
## Proxy Integration Diagram  
![contact-form-diagram-Proxy-integration](https://github.com/user-attachments/assets/38126d9e-af31-4834-b68a-4e95f1ff0753)  


## Non Proxy Integration Diagram  
![contact-form-diagram-NonProxy-integration](https://github.com/user-attachments/assets/8535d860-d6f9-4aea-a30e-20fb4713bc2b)  
  
---
## Project Overview

This project is a serverless contact form on AWS created to explore REST API Gateway integrations — Proxy and Non-Proxy. The goal is to understand how each integration type affects the way Lambda receives input, processes data, and returns responses, giving a clear view of the request/response flow in a serverless application.

**Key Points:**
- **Everything except API Gateway is provisioned using Terraform**, including:
  - S3 bucket (static website)
  - Lambda function
  - DynamoDB table
  - IAM roles & permissions
- **API Gateway is manually configured** to allow **hands-on exploration** of integrations, mapping templates, and CORS behavior. Manual setup provides **practical visibility** of request transformation, Proxy vs Non-Proxy differences, and response handling — essential for understanding real serverless behavior. Terraform could automate this, but automation alone does not teach the internal workings and flows.


---

## Project Architecture

### AWS Components

| Component        | Purpose                                                                                  |
|-----------------|------------------------------------------------------------------------------------------|
| **S3**           | Hosts the static HTML/JS contact form                                                    |
| **API Gateway**  | Receives HTTP requests and triggers Lambda functions                                     |
| **Lambda**       | Validates inputs, generates UUID/timestamp, saves to DynamoDB, returns response          |
| **DynamoDB**     | Stores form submissions with unique IDs and timestamps                                   |
| **Terraform**    | Automates all infrastructure except API Gateway                                          |

---

### High-Level Flow

1. User visits the S3-hosted contact form.  
2. User fills out the form and submits.  
3. Browser sends a **CORS pre-flight request** (OPTIONS) to API Gateway.  
4. API Gateway handles pre-flight:  
   - Returns required CORS headers to confirm the actual request can proceed since **CORS is enabled on this endpoint**.  
   - Confirms the request is allowed by the server before the POST is sent.  
5. Browser sends the actual POST request with the form data --> Form submission reaches Lambda.
   - **Proxy Integration:** Lambda receives **raw HTTP event**, including stringified JSON body, headers, HTTP method, and metadata. Lambda handles:  
     - Parsing `event.body` to extract form data.  
     - Validating that Name, Email, and Message are not empty.
     
   - **Non-Proxy Integration:** API Gateway transforms the request using a **mapping template**. Lambda receives **clean JSON** containing only relevant data. Lambda handles:  
     - Validation of fields.  
     
6. Lambda generates a **unique submission ID (UUID)** and **timestamp** to uniquely identify and track each submission.  
7. Data is saved in DynamoDB:  
   - Lambda sends a **`putItem` request** to DynamoDB with submissionId, Name, Email, Message, and timestamp.  
   - DynamoDB confirms that the record has been successfully stored.  
   - Lambda can optionally log the response for debugging or monitoring(here i dont used it).  
8. Response is returned to API Gateway:  
   - **Proxy Integration:** Lambda sends the HTTP response manually, including status code, headers (CORS), and body.  
   - **Non-Proxy Integration:** Lambda returns only the data object; API Gateway formats the response and adds headers automatically.  
9. Browser displays success message and clears the form. JavaScript parses the response, shows: ✅ "Form submitted successfully!", and resets the form fields for the next submission.  

---

**Reasoning behind the flow:** Sequentially implementing Proxy first, then Non-Proxy, allows **direct comparison and understanding** of each integration style in a controlled manner. 

---

**Kenz Muhammed** C K
GMAIL: kenzmuhammedc@gmail.com
💼 Finding balance between clean infrastructure, useful automation, and real-world simplicity.
