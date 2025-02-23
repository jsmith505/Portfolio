# AWS CloudFront

## **Overview**  
AWS CloudFront is a **Content Delivery Network (CDN)** that securely delivers data, videos, applications, and APIs with low latency and high transfer speeds.

## **Key Concepts**
- **Edge Locations** – Global data centers where content is cached.
- **Regional Edge Caches** – Optimize content delivery between origins and edge locations.
- **Origin** – The source of content (S3, EC2, ALB, etc.).
- **Distributions** – The CloudFront configuration for how content is delivered.
- **Behaviors** – Rules that define how CloudFront handles requests.

## **CloudFront Components**
| **Component**        | **Description** |
|----------------------|----------------|
| **Distributions**    | Defines how content is served through CloudFront. |
| **Origins**         | The backend source (S3, EC2, ALB, etc.). |
| **Cache Behaviors**  | Controls caching, request handling, and allowed HTTP methods. |
| **Edge Locations**  | Where CloudFront caches content globally. |
| **Origin Shield**    | Improves cache hit ratio and reduces load on origin. |

## **Use Cases**
✅ **Accelerating Website Content** – Reduce latency for websites and APIs.  
✅ **Live & On-Demand Video Streaming** – Low-latency content distribution.  
✅ **DDoS Protection & Security** – Integrated with AWS Shield and WAF.  
✅ **API Acceleration** – Speed up REST and GraphQL API responses.  
✅ **Multi-Origin Routing** – Route traffic between multiple backend services.  

## **Cache Optimization**
- **TTL (Time-to-Live)** – Set expiration times to control caching.  
- **Invalidate Cache** – Force an update when content changes.  
- **Compression** – Enable **Gzip or Brotli** for smaller file sizes.  
- **Lambda@Edge** – Customize request/response processing at edge locations.  

## **Security Features**
✔️ **HTTPS Support** – Enforce SSL/TLS for secure connections.  
✔️ **AWS WAF Integration** – Protect against SQL injection & XSS attacks.  
✔️ **Origin Access Control (OAC)** – Secure S3 origins without making them public.  
✔️ **Signed URLs & Cookies** – Restrict access to private content.  
✔️ **AWS Shield Standard** – Free DDoS protection for all CloudFront distributions.  

## **Best Practices**
✔️ Use **OAC instead of OAI** for secure S3 bucket access.  
✔️ Enable **geo-restrictions** to block content in specific regions.  
✔️ Use **CloudFront Functions** or **Lambda@Edge** for custom logic.  
✔️ Monitor with **CloudWatch & AWS X-Ray** for request insights.  
✔️ Optimize caching with **long TTLs** and cache invalidation when necessary.  

---
