#!/bin/bash

function createhospital() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/hospital/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/hospital/


  fabric-ca-client enroll -u https://admin:adminpw@localhost:4400 --caname ca-hospital --tls.certfiles ${PWD}/organizations/fabric-ca/hospital/tls-cert.pem


  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-4400-ca-hospital.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-4400-ca-hospital.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-4400-ca-hospital.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-4400-ca-hospital.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/hospital/msp/config.yaml

  infoln "Registering peer0"

  fabric-ca-client register --caname ca-hospital --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/hospital/tls-cert.pem


  infoln "Registering peer1"

  fabric-ca-client register --caname ca-hospital --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/hospital/tls-cert.pem


  infoln "Registering user"

  fabric-ca-client register --caname ca-hospital --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/hospital/tls-cert.pem


  infoln "Registering the org admin"

  fabric-ca-client register --caname ca-hospital --id.name hospitaladmin --id.secret hospitaladminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/hospital/tls-cert.pem


  infoln "Generating the peer0 msp"

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:4400 --caname ca-hospital -M ${PWD}/organizations/peerOrganizations/hospital/peers/peer0.hospital/msp --csr.hosts peer0.hospital --tls.certfiles ${PWD}/organizations/fabric-ca/hospital/tls-cert.pem


  infoln "Generating the peer1 msp"

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:4400 --caname ca-hospital -M ${PWD}/organizations/peerOrganizations/hospital/peers/peer1.hospital/msp --csr.hosts peer1.hospital --tls.certfiles ${PWD}/organizations/fabric-ca/hospital/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/hospital/msp/config.yaml ${PWD}/organizations/peerOrganizations/hospital/peers/peer0.hospital/msp/config.yaml
  cp ${PWD}/organizations/peerOrganizations/hospital/msp/config.yaml ${PWD}/organizations/peerOrganizations/hospital/peers/peer1.hospital/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:4400 --caname ca-hospital -M ${PWD}/organizations/peerOrganizations/hospital/peers/peer0.hospital/tls --enrollment.profile tls --csr.hosts peer0.hospital --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/hospital/tls-cert.pem

  infoln "Generating the peer1-tls certificates"
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:4400 --caname ca-hospital -M ${PWD}/organizations/peerOrganizations/hospital/peers/peer1.hospital/tls --enrollment.profile tls --csr.hosts peer1.hospital --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/hospital/tls-cert.pem

  cp ${PWD}/organizations/peerOrganizations/hospital/peers/peer0.hospital/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hospital/peers/peer0.hospital/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/hospital/peers/peer0.hospital/tls/signcerts/* ${PWD}/organizations/peerOrganizations/hospital/peers/peer0.hospital/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/hospital/peers/peer0.hospital/tls/keystore/* ${PWD}/organizations/peerOrganizations/hospital/peers/peer0.hospital/tls/server.key



  cp ${PWD}/organizations/peerOrganizations/hospital/peers/peer1.hospital/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hospital/peers/peer1.hospital/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/hospital/peers/peer1.hospital/tls/signcerts/* ${PWD}/organizations/peerOrganizations/hospital/peers/peer1.hospital/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/hospital/peers/peer1.hospital/tls/keystore/* ${PWD}/organizations/peerOrganizations/hospital/peers/peer1.hospital/tls/server.key



  mkdir -p ${PWD}/organizations/peerOrganizations/hospital/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/hospital/peers/peer0.hospital/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hospital/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/hospital/tlsca
  cp ${PWD}/organizations/peerOrganizations/hospital/peers/peer0.hospital/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hospital/tlsca/tlsca.hospital-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/hospital/ca
  cp ${PWD}/organizations/peerOrganizations/hospital/peers/peer0.hospital/msp/cacerts/* ${PWD}/organizations/peerOrganizations/hospital/ca/ca.hospital-cert.pem

  infoln "Generating the user msp"

  fabric-ca-client enroll -u https://user1:user1pw@localhost:4400 --caname ca-hospital -M ${PWD}/organizations/peerOrganizations/hospital/users/User1@hospital/msp --tls.certfiles ${PWD}/organizations/fabric-ca/hospital/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/hospital/msp/config.yaml ${PWD}/organizations/peerOrganizations/hospital/users/User1@hospital/msp/config.yaml

  infoln "Generating the org admin msp"

  fabric-ca-client enroll -u https://hospitaladmin:hospitaladminpw@localhost:4400 --caname ca-hospital -M ${PWD}/organizations/peerOrganizations/hospital/users/Admin@hospital/msp --tls.certfiles ${PWD}/organizations/fabric-ca/hospital/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/hospital/msp/config.yaml ${PWD}/organizations/peerOrganizations/hospital/users/Admin@hospital/msp/config.yaml
}
function createpharmacy() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/pharmacy/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/pharmacy/


  fabric-ca-client enroll -u https://admin:adminpw@localhost:5500 --caname ca-pharmacy --tls.certfiles ${PWD}/organizations/fabric-ca/pharmacy/tls-cert.pem


  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-5500-ca-pharmacy.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-5500-ca-pharmacy.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-5500-ca-pharmacy.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-5500-ca-pharmacy.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/pharmacy/msp/config.yaml

  infoln "Registering peer0"

  fabric-ca-client register --caname ca-pharmacy --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/pharmacy/tls-cert.pem


  infoln "Registering peer1"

  fabric-ca-client register --caname ca-pharmacy --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/pharmacy/tls-cert.pem


  infoln "Registering user"

  fabric-ca-client register --caname ca-pharmacy --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/pharmacy/tls-cert.pem


  infoln "Registering the org admin"

  fabric-ca-client register --caname ca-pharmacy --id.name pharmacyadmin --id.secret pharmacyadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/pharmacy/tls-cert.pem


  infoln "Generating the peer0 msp"

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:5500 --caname ca-pharmacy -M ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer0.pharmacy/msp --csr.hosts peer0.pharmacy --tls.certfiles ${PWD}/organizations/fabric-ca/pharmacy/tls-cert.pem


  infoln "Generating the peer1 msp"

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:5500 --caname ca-pharmacy -M ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer1.pharmacy/msp --csr.hosts peer1.pharmacy --tls.certfiles ${PWD}/organizations/fabric-ca/pharmacy/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/pharmacy/msp/config.yaml ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer0.pharmacy/msp/config.yaml
  cp ${PWD}/organizations/peerOrganizations/pharmacy/msp/config.yaml ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer1.pharmacy/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:5500 --caname ca-pharmacy -M ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer0.pharmacy/tls --enrollment.profile tls --csr.hosts peer0.pharmacy --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/pharmacy/tls-cert.pem

  infoln "Generating the peer1-tls certificates"
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:5500 --caname ca-pharmacy -M ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer1.pharmacy/tls --enrollment.profile tls --csr.hosts peer1.pharmacy --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/pharmacy/tls-cert.pem

  cp ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer0.pharmacy/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer0.pharmacy/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer0.pharmacy/tls/signcerts/* ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer0.pharmacy/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer0.pharmacy/tls/keystore/* ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer0.pharmacy/tls/server.key



  cp ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer1.pharmacy/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer1.pharmacy/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer1.pharmacy/tls/signcerts/* ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer1.pharmacy/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer1.pharmacy/tls/keystore/* ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer1.pharmacy/tls/server.key



  mkdir -p ${PWD}/organizations/peerOrganizations/pharmacy/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer0.pharmacy/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/pharmacy/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/pharmacy/tlsca
  cp ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer0.pharmacy/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/pharmacy/tlsca/tlsca.pharmacy-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/pharmacy/ca
  cp ${PWD}/organizations/peerOrganizations/pharmacy/peers/peer0.pharmacy/msp/cacerts/* ${PWD}/organizations/peerOrganizations/pharmacy/ca/ca.pharmacy-cert.pem

  infoln "Generating the user msp"

  fabric-ca-client enroll -u https://user1:user1pw@localhost:5500 --caname ca-pharmacy -M ${PWD}/organizations/peerOrganizations/pharmacy/users/User1@pharmacy/msp --tls.certfiles ${PWD}/organizations/fabric-ca/pharmacy/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/pharmacy/msp/config.yaml ${PWD}/organizations/peerOrganizations/pharmacy/users/User1@pharmacy/msp/config.yaml

  infoln "Generating the org admin msp"

  fabric-ca-client enroll -u https://pharmacyadmin:pharmacyadminpw@localhost:5500 --caname ca-pharmacy -M ${PWD}/organizations/peerOrganizations/pharmacy/users/Admin@pharmacy/msp --tls.certfiles ${PWD}/organizations/fabric-ca/pharmacy/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/pharmacy/msp/config.yaml ${PWD}/organizations/peerOrganizations/pharmacy/users/Admin@pharmacy/msp/config.yaml
}
function createlaboratory() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/laboratory/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/laboratory/


  fabric-ca-client enroll -u https://admin:adminpw@localhost:6600 --caname ca-laboratory --tls.certfiles ${PWD}/organizations/fabric-ca/laboratory/tls-cert.pem


  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-6600-ca-laboratory.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-6600-ca-laboratory.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-6600-ca-laboratory.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-6600-ca-laboratory.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/laboratory/msp/config.yaml

  infoln "Registering peer0"

  fabric-ca-client register --caname ca-laboratory --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/laboratory/tls-cert.pem


  infoln "Registering peer1"

  fabric-ca-client register --caname ca-laboratory --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/laboratory/tls-cert.pem


  infoln "Registering user"

  fabric-ca-client register --caname ca-laboratory --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/laboratory/tls-cert.pem


  infoln "Registering the org admin"

  fabric-ca-client register --caname ca-laboratory --id.name laboratoryadmin --id.secret laboratoryadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/laboratory/tls-cert.pem


  infoln "Generating the peer0 msp"

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6600 --caname ca-laboratory -M ${PWD}/organizations/peerOrganizations/laboratory/peers/peer0.laboratory/msp --csr.hosts peer0.laboratory --tls.certfiles ${PWD}/organizations/fabric-ca/laboratory/tls-cert.pem


  infoln "Generating the peer1 msp"

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:6600 --caname ca-laboratory -M ${PWD}/organizations/peerOrganizations/laboratory/peers/peer1.laboratory/msp --csr.hosts peer1.laboratory --tls.certfiles ${PWD}/organizations/fabric-ca/laboratory/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/laboratory/msp/config.yaml ${PWD}/organizations/peerOrganizations/laboratory/peers/peer0.laboratory/msp/config.yaml
  cp ${PWD}/organizations/peerOrganizations/laboratory/msp/config.yaml ${PWD}/organizations/peerOrganizations/laboratory/peers/peer1.laboratory/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6600 --caname ca-laboratory -M ${PWD}/organizations/peerOrganizations/laboratory/peers/peer0.laboratory/tls --enrollment.profile tls --csr.hosts peer0.laboratory --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/laboratory/tls-cert.pem

  infoln "Generating the peer1-tls certificates"
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:6600 --caname ca-laboratory -M ${PWD}/organizations/peerOrganizations/laboratory/peers/peer1.laboratory/tls --enrollment.profile tls --csr.hosts peer1.laboratory --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/laboratory/tls-cert.pem

  cp ${PWD}/organizations/peerOrganizations/laboratory/peers/peer0.laboratory/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/laboratory/peers/peer0.laboratory/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/laboratory/peers/peer0.laboratory/tls/signcerts/* ${PWD}/organizations/peerOrganizations/laboratory/peers/peer0.laboratory/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/laboratory/peers/peer0.laboratory/tls/keystore/* ${PWD}/organizations/peerOrganizations/laboratory/peers/peer0.laboratory/tls/server.key



  cp ${PWD}/organizations/peerOrganizations/laboratory/peers/peer1.laboratory/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/laboratory/peers/peer1.laboratory/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/laboratory/peers/peer1.laboratory/tls/signcerts/* ${PWD}/organizations/peerOrganizations/laboratory/peers/peer1.laboratory/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/laboratory/peers/peer1.laboratory/tls/keystore/* ${PWD}/organizations/peerOrganizations/laboratory/peers/peer1.laboratory/tls/server.key



  mkdir -p ${PWD}/organizations/peerOrganizations/laboratory/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/laboratory/peers/peer0.laboratory/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/laboratory/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/laboratory/tlsca
  cp ${PWD}/organizations/peerOrganizations/laboratory/peers/peer0.laboratory/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/laboratory/tlsca/tlsca.laboratory-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/laboratory/ca
  cp ${PWD}/organizations/peerOrganizations/laboratory/peers/peer0.laboratory/msp/cacerts/* ${PWD}/organizations/peerOrganizations/laboratory/ca/ca.laboratory-cert.pem

  infoln "Generating the user msp"

  fabric-ca-client enroll -u https://user1:user1pw@localhost:6600 --caname ca-laboratory -M ${PWD}/organizations/peerOrganizations/laboratory/users/User1@laboratory/msp --tls.certfiles ${PWD}/organizations/fabric-ca/laboratory/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/laboratory/msp/config.yaml ${PWD}/organizations/peerOrganizations/laboratory/users/User1@laboratory/msp/config.yaml

  infoln "Generating the org admin msp"

  fabric-ca-client enroll -u https://laboratoryadmin:laboratoryadminpw@localhost:6600 --caname ca-laboratory -M ${PWD}/organizations/peerOrganizations/laboratory/users/Admin@laboratory/msp --tls.certfiles ${PWD}/organizations/fabric-ca/laboratory/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/laboratory/msp/config.yaml ${PWD}/organizations/peerOrganizations/laboratory/users/Admin@laboratory/msp/config.yaml
}
function createorderer1() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/orderer1

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/orderer1


  fabric-ca-client enroll -u https://admin:adminpw@localhost:2200 --caname ca-orderer1 --tls.certfiles ${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem


  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-2200-ca-orderer1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-2200-ca-orderer1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-2200-ca-orderer1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-2200-ca-orderer1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/orderer1/msp/config.yaml

  infoln "Registering orderer"

  fabric-ca-client register --caname ca-orderer1 --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem


  infoln "Registering the orderer admin"

  fabric-ca-client register --caname ca-orderer1 --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem


  infoln "Generating the orderer msp"

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:2200 --caname ca-orderer1 -M ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/msp --csr.hosts orderer1 --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem


  cp ${PWD}/organizations/ordererOrganizations/orderer1/msp/config.yaml ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/msp/config.yaml

  infoln "Generating the orderer-tls certificates"

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:2200 --caname ca-orderer1 -M ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls --enrollment.profile tls --csr.hosts orderer1 --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem


  cp ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls/keystore/* ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/msp/tlscacerts/tlsca-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/orderer1/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/orderer1/msp/tlscacerts/tlsca-cert.pem

  infoln "Generating the admin msp"

  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:2200 --caname ca-orderer1 -M ${PWD}/organizations/ordererOrganizations/orderer1/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem


  cp ${PWD}/organizations/ordererOrganizations/orderer1/msp/config.yaml ${PWD}/organizations/ordererOrganizations/orderer1/users/Admin@example.com/msp/config.yaml
}



