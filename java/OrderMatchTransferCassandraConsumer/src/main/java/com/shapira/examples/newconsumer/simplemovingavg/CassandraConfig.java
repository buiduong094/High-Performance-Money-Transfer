package com.shapira.examples.newconsumer.simplemovingavg;

import java.net.InetSocketAddress;

import com.datastax.oss.driver.api.core.CqlSession;

public class CassandraConfig {
    private static CassandraConfig instance;
    private CqlSession session;

    private String contactPoints;
    private int port;
    private String keyspace;
    private String datacenter;

    public String getContactPoints() {
      return contactPoints;
    }

    public CassandraConfig(String contactPoints, int port, String keyspace, String datacenter) {
      this.contactPoints = contactPoints;
      this.port = port;
      this.keyspace = keyspace;
      this.datacenter = datacenter;
      session = CqlSession.builder()
      .addContactPoint(new InetSocketAddress(contactPoints, port))
      .withLocalDatacenter(datacenter)
      .withKeyspace(keyspace)
      .build();
    }

    public void setContactPoints(String contactPoints) {
      this.contactPoints = contactPoints;
    }

    public int getPort() {
      return port;
    }

    public void setPort(int port) {
      this.port = port;
    }

    public String getKeyspace() {
      return keyspace;
    }

    public void setKeyspace(String keyspace) {
      this.keyspace = keyspace;
    }

    public String getDatacenter() {
      return datacenter;
    }

    public void setDatacenter(String datacenter) {
      this.datacenter = datacenter;
    }

    public static synchronized CassandraConfig getInstance(String contactPoints, int port, String keyspace, String datacenter) {
      if (instance == null) {
          instance = new CassandraConfig(contactPoints, port, keyspace, datacenter);
      }
      return instance;
  }

  public CqlSession getSession() {
      return session;
  }

  public void close() {
      if (session != null) {
          session.close();
      }
  }
}
