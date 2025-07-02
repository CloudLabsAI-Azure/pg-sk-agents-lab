-- ===============================================
-- EXTENSION SETUP (Azure PostgreSQL Flexible Server only)
-- ===============================================

CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS azure_ai;

-- ===============================================
-- CONFIGURE AZURE OPENAI SETTINGS
-- NOTE: You must be a user with the 'azure_ai_settings_manager' role to run these
-- Replace with your actual values
-- ===============================================

SELECT azure_ai.set_setting('azure_openai.subscription_key', '');
SELECT azure_ai.set_setting('azure_openai.endpoint', '');

-- ===============================================
-- CLEANUP: DROP OLD FUNCTIONS
-- ===============================================

DROP FUNCTION IF EXISTS semantic_relevance(TEXT, INT);
DROP FUNCTION IF EXISTS semantic_relevance_table(TEXT, INT);
DROP FUNCTION IF EXISTS semantic_relevance_json(TEXT, INT);
DROP FUNCTION IF EXISTS generate_json_pairs(TEXT, INT);

-- ===============================================
-- FUNCTION: semantic_relevance (Used by Semantic Kernel plugin)
-- Returns JSONB array of ranked results for re-ranking
-- ===============================================

CREATE OR REPLACE FUNCTION semantic_relevance(query TEXT, n INT)
RETURNS jsonb AS $$
BEGIN
    RETURN (
        SELECT jsonb_agg(
            jsonb_build_object(
                'id', id,
                'similarity', opinions_vector <=> azure_openai.create_embeddings('text-embedding-3-small', query)::vector
            )
        )
        FROM (
            SELECT id, opinions_vector
            FROM cases
            ORDER BY opinions_vector <=> azure_openai.create_embeddings('text-embedding-3-small', query)::vector
            LIMIT n
        ) subquery
    );
END;
$$ LANGUAGE plpgsql;

-- ===============================================
-- FUNCTION: semantic_relevance_table (For direct SQL use)
-- ===============================================

CREATE OR REPLACE FUNCTION semantic_relevance_table(query TEXT, n INT)
RETURNS TABLE (
    case_id INT,
    similarity FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT id, opinions_vector <=> azure_openai.create_embeddings('text-embedding-3-small', query)::vector AS similarity
    FROM cases
    ORDER BY similarity
    LIMIT n;
END;
$$ LANGUAGE plpgsql;

-- ===============================================
-- FUNCTION: semantic_relevance_json (Optional UI/Debugging)
-- ===============================================

CREATE OR REPLACE FUNCTION semantic_relevance_json(query TEXT, n INT)
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
END;
$$ LANGUAGE plpgsql;

-- ===============================================
-- SAMPLE USAGE:
-- SELECT * FROM jsonb_array_elements(semantic_relevance('water leak', 5));
-- SELECT * FROM semantic_relevance_table('water leak', 5);
-- SELECT * FROM semantic_relevance_json('water leak', 5);
-- ===============================================
