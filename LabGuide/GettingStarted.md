# Postgre SQL and SK Agents Lab

### Overall Estimated Duration: 4 Hours

## Overview

Large Language Models (LLMs) enhance modern applications with advanced semantic capabilities, enabling natural language understanding and contextual search. This lab focuses on building an agent-driven Retrieval-Augmented Generation (RAG) application that explores a U.S. Case Law dataset to retrieve factual information. You’ll work with Azure Database for PostgreSQL, Visual Studio Code, and the Semantic Kernel Agent Framework, while applying practical AI and information retrieval techniques such as using vector embeddings within databases and implementing the DiskANN index for fast, high-dimensional vector search.

The lab begins by setting up a data environment and configuring Azure AI extensions before moving into text search using pattern matching. It then introduces semantic vector search, showing how vector indexes dramatically improve search accuracy and relevance. Building on this, the lab incorporates the GraphRAG pattern using Apache AGE, adding graph database functionality to PostgreSQL. This integration enables agents to query both structured and graph-based data, enriching results with interconnected knowledge extracted from relationships within the dataset.

## Objective 

By the end of this lab, you will be able to:

- **Lab1**: we will set up and populate the data in the database, as well as the Azure AI extension, and test the tools that we will use. Part 2 explores how to perform text searches using pattern matching, and demonstrates in practice how this can be significantly improved by relying on semantic vector search and vector indexes
- lAB 2: we delve deeply into creating an agent that uses the GraphRAG pattern, a technique designed to improve the quality of results by extracting knowledge graph information from our data. Let's get started!

## Prerequisites

Participants should have:

- Basic understanding of Azure services such as Azure OpenAI, and models.
- Experience with deploying applications using Azure Developer CLI (AZD).


## Explanation of Components

Semantic Kernel is an open-source SDK developed by Microsoft that helps developers create advanced AI agents by combining:

LLMs (Large Language Models) like OpenAI's GPT models
Plugins (custom tools and functions the agent can call)
Memory (saving and recalling past conversations or facts)
An Agent in Semantic Kernel is a smart assistant that can:

Respond to user prompts
Decide which plugin functions to call
Use external knowledge sources like databases or APIs
Build better, grounded answers by combining model reasoning with real-world data
You are about to connect powerful components:

Azure OpenAI (for embeddings and LLM chat completions)
PostgreSQL with Vector and Graph extensions (for fast semantic and graph search)
APIs for real-world data (historical weather evidence)

## Getting Started with the lab

Welcome to your Azure Agentic AI Workshop, Let's begin by making the most of this experience:

## Accessing Your Lab Environment

Once you're ready to dive in, your virtual machine and **Guide** will be right at your fingertips within your web browser.

![Access Your VM and Lab Guide](./media/VmImage.png)

## Lab Guide Zoom In/Zoom Out

To adjust the zoom level for the environment page, click the **A↕ : 100%** icon located next to the timer in the lab environment.

![](./media/agg2.png)

## Virtual Machine & Lab Guide

Your virtual machine is your workhorse throughout the workshop. The lab guide is your roadmap to success.

## Exploring Your Lab Resources

To get a better understanding of your lab resources and credentials, navigate to the **Environment** tab.

![Explore Lab Resources](./media/agg3.png)

## Utilizing the Split Window Feature

For convenience, you can open the lab guide in a separate window by selecting the **Split Window** button from the Top right corner.

![Use the Split Window Feature](./media/agg4.png)

## Managing Your Virtual Machine

Feel free to **start, stop, or restart (2)** your virtual machine as needed from the **Resources (1)** tab. Your experience is in your hands!

![Manage Your Virtual Machine](./media/agg5.png)

<!-- ## Lab Duration Extension

1. To extend the duration of the lab, kindly click the **Hourglass** icon in the top right corner of the lab environment.

    ![Manage Your Virtual Machine](./media/media/gext.png)

    >**Note:** You will get the **Hourglass** icon when 10 minutes are remaining in the lab.

2. Click **OK** to extend your lab duration.

   ![Manage Your Virtual Machine](./media/media/gext2.png)

3. If you have not extended the duration prior to when the lab is about to end, a pop-up will appear, giving you the option to extend. Click **OK** to proceed. -->

> **Note:** Please ensure the script continues to run and is not terminated after accessing the environment.

## Let's Get Started with Azure Portal

1. On your virtual machine, click on the Azure Portal icon.
2. You'll see the **Sign into Microsoft Azure** tab. Here, enter your credentials:

   - **Email/Username:** <inject key="AzureAdUserEmail"></inject>

     ![Enter Your Username](./media/gt-5.png)

3. Next, provide your password:

   - **Password:** <inject key="AzureAdUserPassword"></inject>

     ![Enter Your Password](./media/gt-4.png)

4. If **Action required** pop-up window appears, click on **Ask later**.
5. If prompted to **stay signed in**, you can click **No**.
6. If a **Welcome to Microsoft Azure** pop-up window appears, simply click **"Cancel"** to skip the tour.

## Steps to Proceed with MFA Setup if "Ask Later" Option is Not Visible

1. At the **"More information required"** prompt, select **Next**.

1. On the **"Keep your account secure"** page, select **Next** twice.

1. **Note:** If you don’t have the Microsoft Authenticator app installed on your mobile device:

   - Open **Google Play Store** (Android) or **App Store** (iOS).
   - Search for **Microsoft Authenticator** and tap **Install**.
   - Open the **Microsoft Authenticator** app, select **Add account**, then choose **Work or school account**.

1. A **QR code** will be displayed on your computer screen.

1. In the Authenticator app, select **Scan a QR code** and scan the code displayed on your screen.

1. After scanning, click **Next** to proceed.

1. On your phone, enter the number shown on your computer screen in the Authenticator app and select **Next**.
1. If prompted to stay signed in, you can click "No."

1. If a **Welcome to Microsoft Azure** pop-up window appears, simply click "Maybe Later" to skip the tour.

## Support Contact

The CloudLabs support team is available 24/7, 365 days a year, via email and live chat to ensure seamless assistance at any time. We offer dedicated support channels tailored specifically for both learners and instructors, ensuring that all your needs are promptly and efficiently addressed.

Learner Support Contacts:

- Email Support: [cloudlabs-support@spektrasystems.com](mailto:cloudlabs-support@spektrasystems.com)
- Live Chat Support: https://cloudlabs.ai/labs-support

Click **Next** from the bottom right corner to embark on your Lab journey!

![Start Your Azure Journey](./media/agg6.png)

Now you're all set to explore the powerful world of technology. Feel free to reach out if you have any questions along the way. Enjoy your workshop!

