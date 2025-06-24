# Lab 1: PostgreSQL and SK Agents

Large-Language Models (LLMs) enhance applications with semantic capabilities, such as natural language search. This lab will guide you to develop an agent-driven, Retrieval-Augmented Generation (RAG) application to explore the U.S. Case Law dataset for factual information.

You will gain hands-on experience in building an agent-based app using Azure Database for PostgreSQL, Visual Studio Code, and the Semantic Kernel Agent Framework. This course will not only cover these technologies but also delve into AI and information retrieval techniques in practice, such as database vectors for (LLMs) and the DiskANN index for vector search. Additionally, you will learn how to integrate the GraphRAG pattern using Apache AGE for PostgreSQL, an extension that adds graph database functionality to PostgreSQL, leveraging the Semantic Kernel Agent Framework.

In Part 1, we will set up and populate the data in the database, as well as the Azure AI extension, and test the tools that we will use. Part 2 explores how to perform text searches using pattern matching, and demonstrates in practice how this can be significantly improved by relying on semantic vector search and vector indexes. In Part 3, we delve deeply into creating an agent that uses the GraphRAG pattern, a technique designed to improve the quality of results by extracting knowledge graph information from our data. Let's get started!

## Task 1 - Setup your Azure PostgreSQL Database for your Agentic App

1. On the Azure Portal landing page, search for Resource Groups and select Resource Groups from the list.

   ![](Images/L1-S1.png)

1. Select SKAgents<inject key="Deployment ID" enableCopy="false"/> Resource group.

   ![](Images/L1-S2.png)

1. Verify that the Azure Open AI and Azure Database for PostgreSQL flexible server have been created. Select the PostgreSQL Flexible Server instance.

   ![](Images/L1-S3.png)

1. From the left panel, select  Authentication under Security. Verify that the Authentication method is set to Microsoft Authentication Method only. Click on Add Microsoft Entra Administrators.

   ![](Images/L1-S4.png)

1. In the window that appears, search for <inject key="AzureAdUserEmail"></inject> and select checkbox and click on Select. 

   ![](Images/L1-S5.png)

1. Review that the <inject key="AzureAdUserEmail"></inject> has been selected and click on Save. 

   ![](Images/L1-S6.png)

1. Wait until the deployment gets completed. 

   ![](Images/L1-S7.png)

1. On your LabVM Desktop, Double click the VS Code icon to Open VS Code. 

1. Once inside VS Code, click the Elephant Icon on the left navigation. Once the extension loads, click the "Add Connection" button in the "POSTGRESQL" panel

   ![](Images/L1-S8.png)

1. Select the input type option as "Browse Azure".

    ![](Images/L1-S9.png)

1. This will prompt a popup to ask to login to Azure, click "Allow"

    ![](Images/L1-S10.png)

1. Login with your Lab Credentials

    - Username: <inject key="AzureAdUserEmail"></inject>

      ![](Images/L1-S11.png)

    - Password: <inject key="AzureAdUserPassword"></inject>

      ![](Images/L1-S12.png)

1. Click "Yes, all apps"

    ![](Images/L1-S13.png)

1. Click "Done"

   ![](Images/L1-S14.png)

1. Back on the "Connection Dialog", for each of the options, click each drop down and select the following options:
    1. Subscription: Select the only option provided
    2. Resource Group: Select the only option provided
    3. Location: Select the only option provided
    4. Server: Select the only option provided
    5. Database: Select `cases`
    6. Authentication Type: Entra Auth

   ![](Images/L1-S15.png)

1. Continue to Fill the Following Options on the "Connection Dialog"

   1. Click **"Add Entra ID"**.
   2. Select your previously logged-in **Lab Account**. Once the confirmation window appears, close the browser tab.
   3. Ensure your Lab account is now selected as the **"Azure Account"**.
   4. Enter the **Connection Name** as `lab`.
   5. Leave the **Server Group** to the default value.
   6. Click **"Test Connection"** to verify connectivity.
   7. Click **"Connect"** to finalize the connection.

   - **Note:** Wait for sometime for the connection to establish

   ![](Images/L1-S18.png)
   

## Task 3: Launch PSQL Command Line Shell in VS Code

1. Click on Files from the top left corner and select Select Folder.

   ![](Images/L1-S19.png) 

1. Navigate to `C:\LabFiles` and select the `pg-sk-agents-lab` folder.

1. Click on the Elephant icon from the left. Expand the connection `lab`. 
   - Note: If a pop appears asking you to signin, select the previously logged in Lab Account and close the browser tab once logged in.

1. In the Object Explorer panel in the top left part of the screen, expand the "Databases" node. Right click the database named "Cases" and Select the option "Connect with PSQL"

    !IMAGE[connect-with-psql.jpg](instructions291546/connect-with-psql.jpg)

1. This will open the PSQL Command Line Shell in the VS Code Terminal. Once PSQL loads, you should see a command line shell like `cases=>`

1. To confirm we are in the correct folder context, enter the command: `\! cd`. This should return the folder location: `C:\LabFiles\pg-sk-agents-lab`

   !IMAGE[psql-cmdline.jpg](instructions291546/psql-cmdline.jpg)


1. At the PSQL Command Line Shell, run the following command to add a couple of tables to the cases database and populate them with sample data.
   
   ```
   \i ./Scripts/initialize_dataset.sql;
   ```

1. Execute the following command to allow the extended display to be automatically applied.

   ```
   \x auto
   ```   
   
1. We will retrieve a sample of data from the cases table in our cases dataset. This allows us to examine the structure and content of the data stored in the database.

   ```
   SELECT name FROM cases LIMIT 5;
   ```
    
1. Execute the following command in **VS Code PSQL Command Line Shell** to verify the extensions in your server's *allowlist* 

   ```
   SHOW azure.extensions;
   ```


### Explore the Azure AI schema and Setup `azure_ai` extension

1. Open "Terminal" by clicking the Terminal icon in the Task Menu. Navigate to the path below using the following command: `cd C:\users\labuser\downloads\pg-sk-agents-lab\scripts\`
1. Enter the following script name to run it: `.\get_env.ps1`
1. Copy the values for `AZURE_OPENAI_ENDPOINT` and `AZURE_OPENAI_KEY`

1. Once you have your endpoint and key, go back to VS Code and the PSQL Command Shell, then use the commands below to add your values to the configuration table. Ensure you replace the <code spellcheck="false">{AZURE_OPENAI_ENDPOINT}</code> and <code spellcheck="false">{AZURE_OPENAI_KEY}</code> tokens with the values you copied from the script output.

	> +++SELECT azure_ai.set_setting('azure_openai.endpoint', '{AZURE_OPENAI_ENDPOINT}');+++

    > +++SELECT azure_ai.set_setting('azure_openai.subscription_key', '{AZURE_OPENAI_KEY}');+++    

    When you add the key, the command should look like: 
    * *SELECT azure_ai.set_setting('azure_openai.endpoint', 'https://oai-learn-eastus-123456.openai.azure.com/');*
    * *SELECT azure_ai.set_setting('azure_openai.subscription_key', 'd33a123456781');*

1. You can verify the settings written into the <code spellcheck="false">azure_ai.settings</code> table using the <code spellcheck="false">azure_ai.get_setting()</code> function in the following queries:

	> +++SELECT azure_ai.get_setting('azure_openai.endpoint');+++

    > +++SELECT azure_ai.get_setting('azure_openai.subscription_key');+++

Congratulations, the <code spellcheck="false">azure_ai</code> PostgreSQL extension is now connected to your Azure OpenAI account!

===
### Review the Azure OpenAI schema

The <code spellcheck="false">azure_openai</code> schema provides the ability to integrate the creation of vector embedding of text values into your database using Azure OpenAI. Using this schema, you can [generate embeddings with Azure OpenAI](https://learn.microsoft.com/azure/ai-services/openai/how-to/embeddings) directly from the database to create vector representations of input text, which can then be used in vector similarity searches, as well as consumed by machine learning models. The schema contains a single function, <code spellcheck="false">create_embeddings()</code>, with two overloads. One overload accepts a single input string, and the other expects an array of input strings.

1. Review the details of the functions in the <code spellcheck="false">azure_openai</code> schema.

    * Review in the [Microsoft Documentation](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/generative-ai-azure-openai#configure-openai-endpoint-and-key)

    The docs will show the two overloads of the <code spellcheck="false">azure_openai.create_embeddings()</code> function, allowing you to review the differences between the two versions of the function and the types they return.

2. To provide a simplified example of using the function, run the following query, which creates a vector embedding for a sample query. The <code spellcheck="false">deployment_name</code> parameter in the function is set to <code spellcheck="false">embedding</code>, which is the name of the deployment of the <code spellcheck="false">text-embedding-3-small</code> model in your Azure OpenAI service:

	> +++SELECT LEFT(azure_openai.create_embeddings('text-embedding-3-small', 'Sample text for PostgreSQL Lab')::text, 100) AS vector_preview;+++

The output looks similar to this:

```sql-nocopy
 vector_preview
----+-----------------------------------------------------------
 {0.020068742,0.00022734122,0.0018286322,-0.0064167166,...}
```

Note: for brevity, the vector embeddings are abbreviated in the above output.

[Embeddings](https://learn.microsoft.com/azure/postgresql/flexible-server/generative-ai-overview#embeddings) are a concept in machine learning and natural language processing (NLP) that involves representing objects such as words, documents, or entities, as [vectors](https://learn.microsoft.com/azure/postgresql/flexible-server/generative-ai-overview#vectors) in a multi-dimensional space. Embeddings allow machine learning models to evaluate how closely two pieces of information are related. This technique efficiently identifies relationships and similarities between data, allowing algorithms to identify patterns and make accurate predictions.

The <code spellcheck="false">azure_ai</code> extension allows you to generate embeddings for input text. To enable the generated vectors to be stored alongside the rest of your data in the database, you must install the <code spellcheck="false">vector</code> extension by following the guidance in the [enable vector support in your database](https://learn.microsoft.com/azure/postgresql/flexible-server/how-to-use-pgvector#enable-extension) documentation. However, that is outside of the scope of this exercise.























===

# Part 2 - Using AI-driven features in Postgres

In this section, we will explore how to leverage AI-driven features within PostgreSQL to enhance data processing and analysis. These features can help automate tasks, improve data insights, and provide advanced functionalities that traditional SQL queries may not offer.

>[!alert] For these next tasks, we will switch to using the **VS Code PostgreSQL Extension Query Editor**.  Follow the steps below to use that.

## Open New Query Editor in VS Code PostgreSQL extension

1. If not already there, click on the Elephant Icon on the left navigation to open the VS Code PostgreSQL extension

	!IMAGE[vs-code-elephant.jpg](instructions291546/vs-code-elephant.jpg)

1. Expand the Databases Node, and Right Click on `cases` database, select `New Query` option

	!IMAGE[vscode-new-query.jpg](instructions291546/vscode-new-query.jpg)

1. This will open a new query editor window like below.
    1. Notice on the bottom right, you can see a green circle indicating you are successfully connected to database
    1. Also notice, you can hover your mouse over the green icon and see a popup showing you what database and server host you are connected to
    1. You should be connected to the `cases` database

		!IMAGE[vscode-db-green.jpg](instructions291546/vscode-db-green.jpg)

1. Now let's run a test query in the editor window to see how it works.
    1. Enter the following SQL query below in the query editor

    	> +++SELECT NAME FROM CASES LIMIT 5;+++
    
    1. Next click the green play ">" icon in the top right tool bar.  Notice the results open in PostgreSQL Query Results panel 
    
    	!IMAGE[vscode-query-play.jpg](instructions291546/vscode-query-play.jpg)

===

## Using Pattern matching for queries

>[!alert] For these next tasks, we will use the **VS Code PostgreSQL Extension Query Editor**.  Paste in the queries below into your query editor window.

We will explore how to use the <code spellcheck="false">ILIKE</code> clause in SQL to perform case-insensitive searches within text fields. This is particularly useful when you want to find specific cases or reviews that contain certain keywords.

1. We will start by searching for cases mentioning `"Water leaking into the apartment from the floor above."`

    ```sql
    SELECT id, name, opinion
    FROM cases
    WHERE opinion ILIKE '%Water leaking into the apartment from the floor above';
    ```

    You'll get a result similar to this:

    ```sql-nocopy
    id | name | opinion
    ----+------+---------
    (0 rows)
    ```

	However, it does not find any results because those *exact* words are not mentioned in the opinion. As you can see there are no results for what to user wants to find. We need to try another approach.

    Next we will see how we can improve on this using Semantic Vector Search.

===

## Using Semantic Vector Search and DiskANN Index

In this section, we will focus on generating and storing embedding vectors.  We are going to use these in our Agent App in later steps. Embedding vectors represent data points in a high-dimensional space, allowing for efficient similarity searches and advanced analytics.

### Create, Store and Index Embedding Vectors

Now that we have some sample data, it's time to generate and store the embedding vectors. The <code spellcheck="false">azure_ai</code> extension makes calling the Azure OpenAI embedding API easy.

1. Now, you are ready to install the <code spellcheck="false">vector</code> extension using the [CREATE EXTENSION](https://www.postgresql.org/docs/current/sql-createextension.html) command.

    ```sql
    CREATE EXTENSION IF NOT EXISTS vector;
    ```

1. Add the embedding vector column. The <code spellcheck="false">text-embedding-3-small</code> model is configured to return 1,536 dimensions, so use that for the vector column size.

    ```sql
    ALTER TABLE cases ADD COLUMN opinions_vector vector(1536);
    ```

1. Generate an embedding vector for the opinion of each case by calling Azure OpenAI through the create_embeddings user-defined function, which is implemented by the azure_ai extension:

    ```sql
    UPDATE cases
    SET opinions_vector = azure_openai.create_embeddings('text-embedding-3-small',  name || LEFT(opinion, 8000), max_attempts => 5, retry_delay_ms => 500)::vector
    WHERE opinions_vector IS NULL;
    ```

    >[!alert] This may take several minutes, depending on the available quota.

1. Adding an [DiskANN Vector Index](https://aka.ms/pg-diskann-docs) to improve vector search speed. 

    Using [DiskANN Vector Index in Azure Database for PostgreSQL](https://aka.ms/pg-diskann-blog) - DiskANN is a scalable approximate nearest neighbor search algorithm for efficient vector search at any scale. It offers high recall, high queries per second (QPS), and low query latency, even for billion-point datasets. This makes it a powerful tool for handling large volumes of data. [Learn more about DiskANN from Microsoft](https://aka.ms/pg-diskann-docs). Now, you are ready to install the <code spellcheck="false">pg_diskann</code> extension using the [CREATE EXTENSION](https://www.postgresql.org/docs/current/sql-createextension.html) command.

    ```sql
    CREATE EXTENSION IF NOT EXISTS pg_diskann;
    ```
1. Create the diskann index on a table column that contains vector data.

    ```sql
    CREATE INDEX cases_cosine_diskann ON cases USING diskann(opinions_vector vector_cosine_ops);
    ```
    as you scale your data to millions of rows, DiskANN makes vector search more efficient.

1. See an example vector by running this query:

    ```sql
    SELECT opinions_vector FROM cases LIMIT 1;
    ```

    you will get a result similar to this, but with 1536 vector columns. The output will take up alot of your screen, just hit enter to move down the page to see all of the output:

    ```sql-nocopy
    opinions_vector | 
    [-0.0018742813,-0.04530062,0.055145424, ... ]
    ```
===

### Perform a Semantic Search Query

Now that you have listing data augmented with embedding vectors, it's time to run a semantic search query. To do so, get the query string embedding vector, then perform a cosine search to find the cases whose opinions that are most semantically similar to the query.

1. Generate the embedding for the query string.

    ```sql
    SELECT azure_openai.create_embeddings('text-embedding-3-small', 'Water leaking into the apartment from the floor above.');
    ```

    you will get a result like this:

    ```sql
    create_embeddings | 
    {-0.0020871465,-0.002830255,0.030923981, ...}
    ```
2. Use the embedding in a cosine search (<code spellcheck="false"><=></code> represents cosine distance operation), fetching the top 10 most similar cases to the query.

    ```sql
    SELECT id, name
    FROM cases
    ORDER BY opinions_vector <=> azure_openai.create_embeddings('text-embedding-3-small', 'Water leaking into the apartment from the floor above.')::vector 
    LIMIT 10;
    ```

    You'll get a result similar to this. Results may vary, as embedding vectors are not guaranteed to be deterministic:

    ```sql-nocopy
        id    |                          name                          
        ---------+--------------------------------------------------------
        615468 | Le Vette v. Hardman Estate
        768356 | Uhl Bros. v. Hull
        8848167 | Wilkening v. Watkins Distributors, Inc.
        558730 | Burns v. Dufresne
        594079 | Martindale Clothing Co. v. Spokane & Eastern Trust Co.
        1086651 | Bach v. Sarich
        869848 | Tailored Ready Co. v. Fourth & Pike Street Corp.
        2601920 | Pappas v. Zerwoodis
        4912975 | Conradi v. Arnold
        1091260 | Brant v. Market Basket Stores, Inc.
        (10 rows)

    ```
3. You may also project the <code spellcheck="false">opinion</code> column to be able to read the text of the matching rows whose opinions were semantically similar. For example, this query returns the best match:

    ```sql
    SELECT id, opinion
    FROM cases
    ORDER BY opinions_vector <=> azure_openai.create_embeddings('text-embedding-3-small', 'Water leaking into the apartment from the floor above.')::vector 
    LIMIT 1;
    ```

which prints something like:

```sql-nocopy
    id          | opinion
    ------------+----------------------------
    615468       | "Morris, J.\nAppeal from an order of nonsuit and dismissal, in an action brought by a tenant to recover damages for injuries to her goods, caused by leakage of water from an upper story. The facts, so far as they are pertinent to our inquiry, are about these: The Hardman Estate is the owner of a building on Yesler Way, in Seattle, the lower portion of which is divided into storerooms, and the upper is used as a hotel. Appellant, who was engaged in the millinery business, occupied one of the storerooms under a written lease...."
```

To intuitively understand semantic search, observe that the opinion mentioned doesn't actually contain the terms <code spellcheck="false">"Water leaking into the apartment from the floor above."</code>. However it does highlight a document with a section that says <code spellcheck="false">"nonsuit and dismissal, in an action brought by a tenant to recover damages for injuries to her goods, caused by leakage of water from an upper story"</code> which is similar.


#  Part 3 - Build the Agentic App

Next, we are going to take everything we have learned so far and now build our Agentic App.  For the remainder of this lab, you will work in a Python Jupyter Notebook in VS Code.

>[!alert] While working in the Notebook, there will be two places where you will need username/password and keys, you will need to return to this Lab Manual to get them from the final steps below.

## Open the Notebook

1. Click the "Files" icon in the left navigation bar of VS Code to return to the "Explorer" View
1. Expand the `Code` folder and look for a file name `lab.ipynb`

	!IMAGE[vscode-notebook-open.jpg](instructions291546/vscode-notebook-open.jpg)

	>[!alert] At this point, continue the lab following the guide in the Notebook in VS Code.  You will need to return to the lab manual for two different steps where keys and usernames are needed.

## For Notebook Step Part 3.3

1. Use the following lab credential username for the `user` field in the `DB_CONFIG` object:
    - Username: +++@lab.CloudPortalCredential(User1).Username+++

## For Notebook Step Part 3.3

1. Use the following endpoint and key in the script file `setup_reranker.sql`

	> +++select azure_ai.set_setting('azure_ml.scoring_endpoint','');+++

	> +++select azure_ai.set_setting('azure_ml.endpoint_key', '');+++
