package com.gtf.neuro_sketch.repository;

import com.gtf.neuro_sketch.model.ThemeDescription;
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
public class ThemeDescriptionRepository {

    private final NamedParameterJdbcTemplate namedParameterJdbcTemplate;

    public Long saveThemeDescription(String userId, String content) {
        String sql = """
                INSERT INTO theme_description (user_id, content, created_at)
                VALUES (:userId, :content, :createdAt)
                """;

        LocalDateTime now = LocalDateTime.now();
        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("userId", userId)
                .addValue("content", content)
                .addValue("createdAt", now);

        KeyHolder keyHolder = new GeneratedKeyHolder();
        namedParameterJdbcTemplate.update(sql, params, keyHolder);

        return Objects.requireNonNull(keyHolder.getKey()).longValue();
    }

    public ThemeDescription findLatestByUserId(String userId) {
        String sql = """
                SELECT id, user_id, content, created_at
                FROM theme_description
                WHERE user_id = :userId
                ORDER BY id DESC
                LIMIT 1
                """;

        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("userId", userId);

        List<ThemeDescription> results = namedParameterJdbcTemplate.query(sql, params, this::mapRowToThemeDescription);
        return results.isEmpty() ? null : results.getFirst();
    }

    private ThemeDescription mapRowToThemeDescription(ResultSet rs, int rowNum) throws SQLException {
        return new ThemeDescription(
                rs.getLong("id"),
                rs.getString("user_id"),
                rs.getString("content"),
                rs.getTimestamp("created_at").toLocalDateTime()
        );
    }
}