-- ===============================================
-- SETUP: Azure OpenAI API Configuration
-- ===============================================

-- Set your Azure OpenAI API key
SELECT azure_openai.set_setting('azure_openai.api_key', 'YOUR-OPENAI-API-KEY');

-- Set your Azure OpenAI resource endpoint (base URL without /openai/deployments)
SELECT azure_openai.set_setting('azure_openai.resource_endpoint', 'https://YOUR-RESOURCE-NAME.openai.azure.com/');

-- ===============================================
-- DROP FUNCTION IF EXISTS
-- ===============================================

DROP FUNCTION IF EXISTS semantic_relevance(TEXT, INT);
DROP FUNCTION IF EXISTS generate_json_pairs(TEXT, INT);  -- optional utility function

-- ===============================================
-- FUNCTION: semantic_relevance
-- Purpose: Retrieve top-N most semantically similar cases to a query
-- Returns: JSONB object containing array of ranked cases
-- ===============================================

CREATE OR REPLACE FUNCTION semantic_relevance(query TEXT, n INT)
RETURNS jsonb AS $$
BEGIN
    RETURN (
        SELECT jsonb_build_object(
            'results',
            jsonb_agg(
                jsonb_build_object(
                    'id', id,
                    'opinion', opinion,
                    'similarity', opinions_vector <=> azure_openai.create_embeddings('text-embedding-3-small', query)::vector
                )
            )
        )
        FROM (
            SELECT id, opinion, opinions_vector
            FROM cases
            ORDER BY opinions_vector <=> azure_openai.create_embeddings('text-embedding-3-small', query)::vector
            LIMIT n
        ) subquery
    );
END $$ LANGUAGE plpgsql;

-- ===============================================
-- FUNCTION: generate_json_pairs (Optional)
-- Useful for debugging or reranker training
-- ===============================================

CREATE OR REPLACE FUNCTION generate_json_pairs(query TEXT, n INT)
RETURNS jsonb AS $$
BEGIN
    RETURN (
        SELECT jsonb_build_object(
            'pairs', 
            jsonb_agg(
                jsonb_build_array(query, LEFT(opinion, 800))
            )
        )
        FROM (
            SELECT opinion
            FROM cases
            ORDER BY opinions_vector <=> azure_openai.create_embeddings('text-embedding-3-small', query)::vector
            LIMIT n
        ) subquery
    );
END $$ LANGUAGE plpgsql;

-- ===============================================
-- SAMPLE USAGE
-- ===============================================

-- Get 5 most relevant cases for the query
-- SELECT * FROM jsonb_array_elements(semantic_relevance('water leak in ceiling', 5)->'results') AS elem;

-- ===============================================
-- END OF FILE
-- ===============================================
