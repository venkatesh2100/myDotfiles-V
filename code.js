const members = db['users-with-portfolios'].find().limit(100).toArray();

const platforms = ["Web", "Mobile"];
const statuses = ["New", "Open", "Closed"];
const verificationStatuses = ["Not Verified", "Verified", "In Review", "Blocked"];
const documentUrls = [
  "https://l450v.alamy.com/450v/2h5rd8j/open-passport-blank-template-vector-international-flat-design-style-2h5rd8j.jpg",
  "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTXiPuk0PZwrmpMKx-JWWZfCkEAhtYcn4PPFdvI8qMf2MUBOVIs",
  "https://cdn.vectorstock.com/i/1000v/61/68/international-passport-template-with-sample-vector-23456168.jpg",
];

let insertCount = 0;

members.forEach(member => {
  const numVerifications = Math.floor(Math.random() * 2) + 1; // 2-5 verifications per user

  for (let i = 0; i < numVerifications; i++) {
    const monthsAgo = Math.floor(Math.random() * 12);
    const submittedAt = new Date();
    submittedAt.setMonth(submittedAt.getMonth() - monthsAgo);

    const closedAt = new Date(submittedAt);
    closedAt.setDate(closedAt.getDate() + Math.floor(Math.random() * 30));

    const updatedAt = new Date(closedAt);
    updatedAt.setDate(updatedAt.getDate() + Math.floor(Math.random() * 10));

    db['admin-verification-info'].insertOne({
      memberId: member._id,
      userName: member.memberName,
      userEmail: member.userEmail,
      platform: platforms[Math.floor(Math.random() * platforms.length)],
      documentUrl: documentUrls[Math.floor(Math.random() * documentUrls.length)],
      read: Math.random() > 0.3,
      status: statuses[Math.floor(Math.random() * statuses.length)],
      verification: verificationStatuses[Math.floor(Math.random() * verificationStatuses.length)],
      submittedAt: submittedAt,
      closedAt: closedAt,
      updatedAt: updatedAt
    });

    insertCount++;
  }
});

print(`Inserted ${insertCount} verification documents for ${members.length} members`);





//? command 2: Aggregate userEmail in users-with-portfolios
db['users-with-portfolios'].find().forEach(member => {
  const email = `${member.username}@gmail.com`;

  const documentUrls = [
    "https://l450v.alamy.com/450v/2h5rd8j/open-passport-blank-template-vector-international-flat-design-style-2h5rd8j.jpg",
    "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTXiPuk0PZwrmpMKx-JWWZfCkEAhtYcn4PPFdvI8qMf2MUBOVIs",
    "https://cdn.vectorstock.com/i/1000v/61/68/international-passport-template-with-sample-vector-23456168.jpg",
  ];
  const attachments = Math.floor(Math.random() * documentUrls.length());//Array it may contains more then 1
  db['users-with-portfolios'].updateOne(
    { _id: member._id },
    { $set: { userEmail: email } },
  );
});



//? command 3: Update the Attachements and content.

db['users-with-portfolios'].find().forEach(member => {

  const documentUrls = [
    "https://l450v.alamy.com/450v/2h5rd8j/open-passport-blank-template-vector-international-flat-design-style-2h5rd8j.jpg",
    "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTXiPuk0PZwrmpMKx-JWWZfCkEAhtYcn4PPFdvI8qMf2MUBOVIs",
    "https://cdn.vectorstock.com/i/1000v/61/68/international-passport-template-with-sample-vector-23456168.jpg",
  ];

  // Random attachments (1 to all)
  const randomCount = Math.floor(Math.random() * documentUrls.length) + 1;
  const attachments = [...documentUrls]
    .sort(() => Math.random() - 0.5)
    .slice(0, randomCount);

  const now = new Date();
  const submissionDate = new Date(now.getTime() - Math.random() * 10 * 24 * 60 * 60 * 1000);
  const closeDate = Math.random() > 0.5
    ? new Date(submissionDate.getTime() + Math.random() * 5 * 24 * 60 * 60 * 1000)
    : null;

  db['admin-support-tickets'].insertOne({
    ticketId: "#" + Math.floor(1000 + Math.random() * 9000),

    user: {
      name: member.memberName
    },

    content: "This is a demo support ticket regarding issues encountered in the portfolio management application. The user reports difficulties while uploading verification documents and updating portfolio details. In some cases, attachments fail to save properly, and changes made to profile information do not immediately reflect on the dashboard. The user also experienced slow loading times when accessing the document review section. This ticket has been created to review the reported problems, verify system behavior, and ensure that document uploads, portfolio updates, and related notifications function correctly across all supported platforms and user accounts.",
    documentUrls: attachments,        // 👈 array of document URLs

    submissionDate: submissionDate,
    closeDate: closeDate,

    issueStatus: Math.random() > 0.5 ? "Read" : "Unread",
    status: ["New", "Open", "Closed"][Math.floor(Math.random() * 3)],

    assignedTo: null,
    timeSpentMinutes: Math.floor(Math.random() * 120),

    lastActivityAt: new Date(),
    createdAt: submissionDate,
    updatedAt: new Date()
  })

});



db['users-with-portfolios'].find().forEach(member => {

  const links = [
    "https://l450v.alamy.com/450v/2h5rd8j/open-passport-blank-template-vector-international-flat-design-style-2h5rd8j.jpg",
    "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTXiPuk0PZwrmpMKx-JWWZfCkEAhtYcn4PPFdvI8qMf2MUBOVIs",
    "https://cdn.vectorstock.com/i/1000v/61/68/international-passport-template-with-sample-vector-23456168.jpg",
  ];

  const updatedPortfolios = member.portfolios.map(portfolio => {

    const now = new Date();
    const createdAt = new Date(
      now.getTime() - Math.random() * 10 * 24 * 60 * 60 * 1000
    );

    const randomLink = links[Math.floor(Math.random() * links.length)];

    return {
      ...portfolio,
      portfolioLink: randomLink,
      createdAt: createdAt
    };
  });

  db['users-with-portfolios'].updateOne(
    { _id: member._id },
    { $set: { portfolios: updatedPortfolios } }
  );
});





db['users-with-portfolios'].find().forEach(member => {

  const documentUrls = [
    "https://l450v.alamy.com/450v/2h5rd8j/open-passport-blank-template-vector-international-flat-design-style-2h5rd8j.jpg",
    "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTXiPuk0PZwrmpMKx-JWWZfCkEAhtYcn4PPFdvI8qMf2MUBOVIs",
    "https://cdn.vectorstock.com/i/1000v/61/68/international-passport-template-with-sample-vector-23456168.jpg",
  ];
  const avatar = [
    "https://i.pravatar.cc/40?img=1",
    "https://i.pravatar.cc/40?img=2",
    "https://i.pravatar.cc/40?img=3",
  ]

  const platforms = ["Web", "App"];
  // Random attachments (1 to all)
  const randomCount = Math.floor(Math.random() * documentUrls.length) + 1;

  const attachments = [...documentUrls]
    .sort(() => Math.random() - 0.5)
    .slice(0, randomCount);

  const now = new Date();
  const submissionDate = new Date(now.getTime() - Math.random() * 10 * 24 * 60 * 60 * 1000);
  const closeDate = Math.random() > 0.5
    ? new Date(submissionDate.getTime() + Math.random() * 5 * 24 * 60 * 60 * 1000)
    : null;

  db['admin-user-feedback'].insertOne({
    ticketId: "#" + Math.floor(1000 + Math.random() * 9000),

    user: {
      name: member.memberName
    },
    avatar: avatar[randomCount],
    content: "This is a demo support ticket regarding issues encountered in the portfolio management application. The user reports difficulties while uploading verification documents and updating portfolio details. In some cases, attachments fail to save properly, and changes made to profile information do not immediately reflect on the dashboard. The user also experienced slow loading times when accessing the document review section. This ticket has been created to review the reported problems, verify system behavior, and ensure that document uploads, portfolio updates, and related notifications function correctly across all supported platforms and user accounts.",
    documentUrls: attachments,        // 👈 array of document URLs
    submissionDate: submissionDate,
    closeDate: closeDate,

    issueStatus: Math.random() > 0.5 ? "Read" : "Unread",
    solved: Math.random() > 0.5 ? true : false,
    paltform: Math.random() > 0.5 ? "Web" : "App",
    lastActivityAt: new Date(),
    createdAt: submissionDate,
    updatedAt: new Date()
  })

});


//reanme INReview to In progress

db['admin-verification-info'].find({ verification: "In Review" }).forEach(member => {

  db['admin-verification-info'].updateOne(
    { _id: member._id },
    { $set: { verification: "In Progress" } },
  );
});

