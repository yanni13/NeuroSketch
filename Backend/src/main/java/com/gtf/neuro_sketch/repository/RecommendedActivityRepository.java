package com.gtf.neuro_sketch.repository;

import com.gtf.neuro_sketch.model.RecommendedActivity;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

@Repository
@RequiredArgsConstructor
@Slf4j
public class RecommendedActivityRepository {

    private final NamedParameterJdbcTemplate namedParameterJdbcTemplate;

    public Long saveRecommendedActivity(String userId, String activity) {
        String sql = """
                INSERT INTO recommended_activity (user_id, activity, is_done, created_at, updated_at)
                VALUES (:userId, :activity, :isDone, :createdAt, :updatedAt)
                """;

        LocalDateTime now = LocalDateTime.now();
        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("userId", userId)
                .addValue("activity", activity)
                .addValue("isDone", false)
                .addValue("createdAt", now)
                .addValue("updatedAt", now);

        KeyHolder keyHolder = new GeneratedKeyHolder();
        namedParameterJdbcTemplate.update(sql, params, keyHolder);

        return Objects.requireNonNull(keyHolder.getKey()).longValue();
    }

    public List<RecommendedActivity> findPendingActivitiesByUserId(String userId) {
        String sql = """
                SELECT id, user_id, activity, is_done, created_at, updated_at
                FROM recommended_activity
                WHERE user_id = :userId AND is_done = false
                ORDER BY created_at DESC
                """;

        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("userId", userId);

        return namedParameterJdbcTemplate.query(sql, params, this::mapRowToRecommendedActivity);
    }

    public List<RecommendedActivity> findAllActivitiesByUserId(String userId) {
        String sql = """
                SELECT id, user_id, activity, is_done, created_at, updated_at
                FROM recommended_activity
                WHERE user_id = :userId
                ORDER BY created_at DESC
                """;

        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("userId", userId);

        return namedParameterJdbcTemplate.query(sql, params, this::mapRowToRecommendedActivity);
    }

    public void markActivityAsDone(Long activityId) {
        String sql = """
                UPDATE recommended_activity
                SET is_done = true, updated_at = :updatedAt
                WHERE id = :id
                """;

        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("id", activityId)
                .addValue("updatedAt", LocalDateTime.now());

        namedParameterJdbcTemplate.update(sql, params);
    }

    private RecommendedActivity mapRowToRecommendedActivity(ResultSet rs, int rowNum) throws SQLException {
        return new RecommendedActivity(
                rs.getLong("id"),
                rs.getString("user_id"),
                rs.getString("activity"),
                rs.getBoolean("is_done"),
                rs.getTimestamp("created_at").toLocalDateTime(),
                rs.getTimestamp("updated_at").toLocalDateTime()
        );
    }
}