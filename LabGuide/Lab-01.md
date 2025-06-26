# Lab 1 - PostgreSQL Connection and AI Search Integration

This lab focuses on establishing a connection between Visual Studio Code and a PostgreSQL database, launching the PSQL command-line shell, and integrating AI-driven semantic search capabilities. It involves configuring Azure AI extensions, generating and storing embedding vectors using the Azure OpenAI embedding API, and implementing semantic vector search with the DiskANN index for high-performance similarity queries. The lab demonstrates how to enhance traditional text search with advanced semantic search techniques and prepares data environments for agent-based AI applications by combining structured data, vector embeddings, and AI-powered search queries within PostgreSQL.

## Task 1 : Setup your Azure PostgreSQL Database for your Agentic App

1. On the Azure Portal landing page, search for Resource Groups and select Resource Groups from the list.

   ![](Images/L1-S1.png)

1. Select SKAgents-<inject key="Deployment ID" enableCopy="false"/> Resource group.

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

      ![](Images/Password.png)

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
   

## Task 2: Launch PSQL Command Line Shell in VS Code

1. On the VS Code, click on Files from the top left corner and select Select Folder.

   ![](Images/L1-S19.png) 

1. Navigate to `C:\LabFiles` and select the `pg-sk-agents-lab` folder.

   ![](Images/L1-S20.png) 

1. Select "I trust the authors"  

   ![](Images/L1-S21.png)

1. Expand Scripts folder and open get_env.ps1. Update the Resource Group name as SKAgents-<inject key="Deployment ID" enableCopy="false"/> and save the file.

   ![](Images/E1-S45.png)

1. Minimise the VS Code and On the Lab VM , Search Powershell in the Search bar and select Powershell. 

   ![](Images/E1-S44.png) 

1. Execute the below command to login into Azure. 

   ```
   az login
   ```
   ![](Images/E1-S46.png)

1. On the window that appears, select the azure account that was used to login earlier.

   ![](Images/E1-S47.png)

1. Back on the terminal, type 1 and enter to select the default subscription that appears.

   ![](Images/E1-S48.png)

1. Execute the below command to navigate to the scripts folder.
  
   ```
   cd C:\LabFiles\pg-sk-agents-lab\scripts\
   ```
   
   ![](Images/L1-S30.png)

1. Execute the following command to run the script to fetch details.

   ```
   .\get_env.ps1
   ```
1. Copy the values for `AZURE_OPENAI_ENDPOINT` and `AZURE_OPENAI_KEY` from the output and paste in into a notepad for further use and close the terminal. 

   ![](Images/E1-S48.png)

1. Maximize the VS code. Click on the Elephant icon from the left. Expand the connection `lab`. 
   - Note: If a pop appears asking you to signin, select the previously logged in Azure Account and close the browser tab once logged in.

   ![](Images/L1-S22.png)

1. In the Object Explorer panel in the top left part of the screen, expand the "Databases" node. Right click the database named "Cases" and Select the option "Connect with PSQL"

   ![](Images/L1-S23.png)

1. This will open the PSQL Command Line Shell in the VS Code Terminal. Once PSQL loads, you should see a command line shell like `cases=>`

   ![](Images/L1-S24.png)

1. To confirm we are in the correct folder context, enter the command: `\! cd`.

   ![](Images/L1-S25.png)


1. At the PSQL Command Line Shell, run the following command to add a couple of tables to the cases database and populate them with sample data.
   
   ```
   \i ./Scripts/initialize_dataset.sql;
   ```
   ![](Images/L1-S26.png)

1. Execute the following command to allow the extended display to be automatically applied.

   ```
   \x auto
   ```   
   ![](Images/L1-S27.png)   
   
1. We will retrieve a sample of data from the cases table in our cases dataset. This allows us to examine the structure and content of the data stored in the database.

   ```
   SELECT name FROM cases LIMIT 5;
   ```
   ![](Images/L1-S28.png)  
 
1. Execute the following command in **VS Code PSQL Command Line Shell** to verify the extensions in your server's *allowlist* 

   ```
   SHOW azure.extensions;
   ```
   ![](Images/L1-S29.png)  

 
1. Execute the commands below to add values to the configuration table. Ensure to replace {AZURE_OPENAI_ENDPOINT} and {AZURE_OPENAI_KEY} tokens with the values you copied in the earlier step.

   ```
   SELECT azure_ai.set_setting('azure_openai.endpoint', '{AZURE_OPENAI_ENDPOINT}');
   ```
   ```
   SELECT azure_ai.set_setting('azure_openai.subscription_key', '{AZURE_OPENAI_KEY}');
   ``` 
   ![](Images/L1-S30.png)     

1. Verify the settings written into the azure_ai.settings table using the following queries:

   ```
   SELECT azure_ai.get_setting('azure_openai.endpoint');
   ```

   ```
   SELECT azure_ai.get_setting('azure_openai.subscription_key');
   ```   

   ![](Images/L1-S31.png)    

1. Run the following query, which creates a vector embedding for a sample query. The **deployment_name** parameter in the function is set to **embedding**, which is the name of the deployment of the **text-embedding-3-small** model in your Azure OpenAI service:

   ```
   SELECT LEFT(azure_openai.create_embeddings('text-embedding-3-small', 'Sample text for PostgreSQL Lab')::text, 100) AS vector_preview;
   ```
   ![](Images/L1-S32.png)      

## Task 3 - Using AI-driven features in Postgres

In this section, we will explore how to leverage AI-driven features within PostgreSQL to enhance data processing and analysis. These features can help automate tasks, improve data insights, and provide advanced functionalities that traditional SQL queries may not offer.

1. On the VS Code, expand the Databases Node, and Right Click on `cases` database, select `New Query` option.

   ![](Images/L1-S33.png) 

1. This will open a new query editor window like below. Notice on the bottom right, you can see a green circle indicating you are successfully connected to cases database.

1. Enter the following SQL query below in the query editor to run a test query. Click the green play ">" icon in the top right tool bar. Notice the results open in PostgreSQL Query Results panel.

   ```
   SELECT NAME FROM CASES LIMIT 5;
   ``` 

   ![](Images/L1-S34.png)  

1. We will start by searching for cases mentioning `"Water leaking into the apartment from the floor above."` to perform case-insensitive searches within text fields. Paste the below query in the query editor and run the query. 

   ```
   SELECT id, name, opinion
   FROM cases
   WHERE opinion ILIKE '%Water leaking into the apartment from the floor above';
   ```
   ![](Images/L1-S34.png) 

   > Note: It does not find any results because those *exact* words are not mentioned in the opinion. As you can see there are no results for what to user wants to find. We need to try another approach.


## Task 4: Using Semantic Vector Search and DiskANN Index

In this section, we will focus on generating and storing embedding vectors.  We are going to use these in our Agent App in later steps. Embedding vectors represent data points in a high-dimensional space, allowing for efficient similarity searches and advanced analytics.
Now that we have some sample data, it's time to generate and store the embedding vectors. The <code spellcheck="false">azure_ai</code> extension makes calling the Azure OpenAI embedding API easy.

1. Now, you are ready to install the vector extension.

    ```sql
    CREATE EXTENSION IF NOT EXISTS vector;
    ```
   ![](Images/L1-S35.png) 

1. Add the embedding vector column. The <code spellcheck="false">text-embedding-3-small</code> model is configured to return 1,536 dimensions, so use that for the vector column size.

    ```sql
    ALTER TABLE cases ADD COLUMN opinions_vector vector(1536);
    ```

   ![](Images/L1-S36.png) 

1. Generate an embedding vector for the opinion of each case by calling Azure OpenAI through the create_embeddings user-defined function, which is implemented by the azure_ai extension:

    ```sql
    UPDATE cases
    SET opinions_vector = azure_openai.create_embeddings('text-embedding-3-small',  name || LEFT(opinion, 8000), max_attempts => 5, retry_delay_ms => 500)::vector
    WHERE opinions_vector IS NULL;
    ```
   ![](Images/L1-S37.png) 

    >Note: This may take several minutes to run.

1. Adding an DiskANN Vector Index to improve vector search speed. 

    ```sql
    CREATE EXTENSION IF NOT EXISTS pg_diskann;
    ```

   ![](Images/L1-S38.png) 

1. Create the diskann index on a table column that contains vector data. As you scale your data to millions of rows, DiskANN makes vector search more efficient.

    ```sql
    CREATE INDEX cases_cosine_diskann ON cases USING diskann(opinions_vector vector_cosine_ops);
    ```
   ![](Images/L1-S39.png) 

1. See an example vector by running the below query.The output will take up alot of your screen, just hit enter to move down the page to see all of the output:

    ```sql
    SELECT opinions_vector FROM cases LIMIT 1;
    ```
    >Note: The output will take up alot of your screen, just hit enter to move down the page to see all of the output

   ![](Images/L1-S40.png) 

## Task 5: Perform a Semantic Search Query

Now that you have listing data augmented with embedding vectors, it's time to run a semantic search query. To do so, get the query string embedding vector, then perform a cosine search to find the cases whose opinions that are most semantically similar to the query.

1. Generate the embedding for the query string.

    ```sql
    SELECT azure_openai.create_embeddings('text-embedding-3-small', 'Water leaking into the apartment from the floor above.');
    ```

   ![](Images/L1-S41.png) 

2. Use the embedding in a cosine search, fetching the top 10 most similar cases to the query.

    ```sql
    SELECT id, name
    FROM cases
    ORDER BY opinions_vector <=> azure_openai.create_embeddings('text-embedding-3-small', 'Water leaking into the apartment from the floor above.')::vector 
    LIMIT 10;
    ```

   ![](Images/L1-S42.png) 

3. You may also project the <code spellcheck="false">opinion</code> column to be able to read the text of the matching rows whose opinions were semantically similar. For example, this query returns the best match:

    ```sql
    SELECT id, opinion
    FROM cases
    ORDER BY opinions_vector <=> azure_openai.create_embeddings('text-embedding-3-small', 'Water leaking into the apartment from the floor above.')::vector 
    LIMIT 1;
    ```

   ![](Images/L1-S43.png) 
